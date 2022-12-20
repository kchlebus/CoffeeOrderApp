//
//  NetworkError.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 15/12/2022.
//

import Foundation

enum NetworkError: Error {
  case badUrl
  case badRequest
  case decodingError
  case encodingError
  case missingObjectId
}
