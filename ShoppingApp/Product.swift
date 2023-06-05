//
//  Product.swift
//  ShoppingApp
//
//  Created by patelpra on 6/3/23.
//

import Foundation

struct Product: Identifiable, Codable {
  var id: Int
  var itemId: String
  var title: String
  var description: String
  var price: String
  var categoryPath: String
  var categoryIdPath: String
  var image: String
}
// MARK: Assignment 2
enum ProductError: Error {
  case badURLRequest
  case invalidResponse
  case invalidData
  case encodingError
}

