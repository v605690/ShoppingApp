//
//  ShoppingList.swift
//  ShoppingApp
//
//  Created by patelpra on 6/3/23.
//

import Foundation

class ShoppingList: ObservableObject {

  @Published var products: [Product] = [] {

    didSet {
      Task {
        try await saveListItems()
      }
    }
  }
// MARK: Assignment 1
  func getProducts() async throws {
    let (data, response) = try await URLSession.shared.data(from: URL(string: "http://www.grupodlt.com/stamps/hip.json")!)

    guard let response = response as?
            HTTPURLResponse, response.statusCode == 200 else {
      throw ProductError.invalidResponse

    }

    Task { @MainActor in
      self.products = try JSONDecoder().decode([Product].self, from: data)
    }
  }

  // MARK: NEW save method
  func saveListItems() async throws {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      throw ProductError.badURLRequest
    }
    
    let jsonFile = documentDirectory.appendingPathComponent("newStamp.json")
    let urlString = "http://www.grupodlt.com/stamps/hip.json"
    
    guard let jsonURL = URL(string: urlString) else {
      throw ProductError.badURLRequest
    }
    let (data, response) = try await URLSession.shared.data(from: jsonURL)
    try data.write(to: jsonFile)
    
    guard let response = response as?
            HTTPURLResponse, response.statusCode == 200 else {
      throw ProductError.invalidResponse
    }
  }
  // MARK: OLD save method
  func saveListItems() {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    let jsonFile = documentDirectory.appendingPathComponent("newStamp.json")
    let urlString = "http://www.grupodlt.com/stamps/hip.json"

    if let jsonURL = URL(string: urlString) {
      let downloadTask = URLSession.shared.downloadTask(with: jsonURL) { (tempFileUrl, response, error) in

        if let jsonTempFileUrl = tempFileUrl {
          do {
            let fileData = try Data(contentsOf: jsonTempFileUrl)
            try fileData.write(to: jsonFile)
          } catch {
            print("unkown error")
          }
        }
      }
      downloadTask.resume()
    }
  }
}
