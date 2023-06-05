//
//  ContentView.swift
//  ShoppingApp
//
//  Created by patelpra on 6/3/23.
//

import SwiftUI

struct ContentView: View {

  @StateObject private var shopList = ShoppingList()
  @State private var showingAlert = false

  var body: some View {


    return List(shopList.products, id: \.id) { product in
      ScrollView() {
        Spacer()
        AsyncImage(url: URL(string: product.image)!) { product in
          if let image = product.image {
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
            // MARK: Assignment 3
            } else if product.error != nil {
            Button("Show Alert") {
              showingAlert = true
            }
            Text("No image available")
          } else {
            Image(systemName: "photo")
              .resizable()
              .aspectRatio(contentMode: .fill)
          }
        }.frame(width: 250, height: 250, alignment: .center)
        Text(product.itemId)
          .font(.title2)
        Text(product.title)
          .font(.subheadline)
          .multilineTextAlignment(.center)
        Text(product.price)
          .bold()
          .padding()
        Text(product.categoryPath)
          .font(.subheadline)
          .multilineTextAlignment(.center)
        Text(product.categoryIdPath)
      }
      .navigationTitle("Stamp List")
      .navigationBarItems(trailing:
          Button(action: {
        Task {
          try await shopList.saveListItems()
        }
        //shopList.saveListItems()
      }) {
        Image(systemName: "plus")
      })
    }
    // MARK: Assignment 3
    .alert("No network connection", isPresented: $showingAlert) {
      Button("OK", role: .cancel) {}
    }
    .listStyle(.plain)
    // MARK: Assignment 2 Continued
    .task {
      do {
        try await shopList.getProducts()
      } catch ProductError.badURLRequest{
        print("bad url request")
      } catch ProductError.invalidResponse {
        print("invalid response")
      } catch ProductError.invalidData {
        print("invalid data")
      } catch ProductError.encodingError {
        print("encoding error")
      } catch {
        print("unexpected error")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      ContentView()
    }
  }
}
