//
//  Endpoint.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 20/12/2022.
//

import Foundation

enum Endpoint {
  case allOrders
  case createOrder
  case deleteOrder(id: Int)
  case updateOrder(id: Int)

  var path: String {
    switch self {
    case .allOrders:
      return "/test/orders"
    case .createOrder:
      return "/test/new-order"
    case let .deleteOrder(id), let .updateOrder(id):
      return "/test/orders/\(id)"
    }
  }
}
