//
//  CoffeeOrderAppApp.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 07/12/2022.
//

import SwiftUI

@main
struct CoffeeOrderAppApp: App {
  @StateObject private var coffeeStore: CoffeeStore

  init() {
    let webService = CoffeeWebService(baseUrl: Configuration().environment.baseUrl)
    _coffeeStore = StateObject(wrappedValue: CoffeeStore(webService: webService))
    disableAnimationsWhenTesting()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(coffeeStore)
    }
  }

  func disableAnimationsWhenTesting() {
    let env = ProcessInfo.processInfo.environment
    if env["DISABLE_ANIMATIONS"] == "1" {
      UIView.setAnimationsEnabled(false)
    }
  }
}
