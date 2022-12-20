//
//  AppEnvironment.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 08/12/2022.
//

import Foundation

enum AppEnvironment: String {
  case dev
  case test

  var baseUrl: URL {
    switch self {
    case .dev:
      return URL(string: "https://island-bramble.glitch.me")!
    case .test:
      return URL(string: "https://island-bramble.glitch.me")!
    }
  }
}

struct Configuration {
  var environment: AppEnvironment = {
    if let env = ProcessInfo.processInfo.environment["ENV"], env == "TEST" {
      return .test
    } else {
      return .dev
    }
  }()
}
