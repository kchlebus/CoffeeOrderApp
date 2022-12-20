//
//  WebService.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 07/12/2022.
//

import Foundation

final class CoffeeWebService {
  private let baseUrl: URL

  init(baseUrl: URL) {
    self.baseUrl = baseUrl
  }

  func createOrder(order: Order) async throws -> Order {
    guard let url = URL(string: Endpoint.createOrder.path, relativeTo: baseUrl) else {
      throw NetworkError.badUrl
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(order)

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw NetworkError.badRequest
    }
    guard let createdOrder = try? JSONDecoder().decode(Order.self, from: data) else {
      throw NetworkError.decodingError
    }

    return createdOrder
  }

  func getOrders() async throws -> [Order] {
    guard let url = URL(string: Endpoint.allOrders.path, relativeTo: baseUrl) else {
      throw NetworkError.badUrl
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw NetworkError.badRequest
    }
    guard let orders = try? JSONDecoder().decode([Order].self, from: data) else {
      throw NetworkError.decodingError
    }
    return orders
  }

  func deleteOrder(id: Int) async throws {
    guard let url = URL(string: Endpoint.deleteOrder(id: id).path, relativeTo: baseUrl) else {
      throw NetworkError.badUrl
    }

    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"

    let (_, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw NetworkError.badRequest
    }
  }

  func updateOrder(_ order: Order) async throws -> Order {
    guard let id = order.id else {
      throw NetworkError.missingObjectId
    }
    guard let url = URL(string: Endpoint.updateOrder(id: id).path, relativeTo: baseUrl) else {
      throw NetworkError.badUrl
    }
    guard let encodedOrder = try? JSONEncoder().encode(order) else {
      throw NetworkError.encodingError
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = encodedOrder

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw NetworkError.badRequest
    }
    guard let updatedOrder = try? JSONDecoder().decode(Order.self, from: data) else {
      throw NetworkError.decodingError
    }

    return updatedOrder
  }
}
