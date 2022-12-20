//
//  Order.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 07/12/2022.
//

import Foundation

struct Order: Codable, Identifiable, Hashable {
  var id: Int?
  var name: String
  var coffeeName: String
  var total: Double
  var size: CoffeeSize
}

enum CoffeeSize: String, Codable, CaseIterable {
  case small = "Small"
  case medium = "Medium"
  case large = "Large"
}

extension Order {
  static let preview = Order(id: 33, name: "Kamil's Coffee", coffeeName: "Espresso", total: 2.5, size: .small)
}
