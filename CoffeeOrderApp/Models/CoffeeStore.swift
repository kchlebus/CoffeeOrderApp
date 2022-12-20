//
//  CoffeeStore.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 07/12/2022.
//

import Foundation

@MainActor
final class CoffeeStore: ObservableObject {
  @Published private(set) var orders: [Order] = []

  var webService: CoffeeWebService

  init(webService: CoffeeWebService = CoffeeWebService(baseUrl: Configuration().environment.baseUrl)) {
    self.webService = webService
  }

  func fetchOrders() async throws {
    orders = try await webService.getOrders()
  }

  func createOrder(_ order: Order) async throws {
    let newOrder = try await webService.createOrder(order: order)
    orders.append(newOrder)
  }

  func deleteOrder(id: Int) async throws {
    do {
      try await webService.deleteOrder(id: id)
      orders.removeAll(where: { $0.id == id })
    } catch {
      throw error
    }
  }

  func updateOrder(_ order: Order) async throws {
    let updatedOrder = try await webService.updateOrder(order)
    guard let index = orders.firstIndex(of: order) else {
      throw CoffeeOrderError.invalidOrderId
    }
    orders[index] = updatedOrder
  }
}
