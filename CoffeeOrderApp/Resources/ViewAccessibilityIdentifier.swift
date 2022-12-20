//
//  ViewAccessibilityIdentifier.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 12/12/2022.
//

import UIKit
import SwiftUI

/// Naming convention: "view_componentName"
enum ViewAccessibilityIdentifier: String {
  // ContentView
  case content_addOrderButton
  case content_noOrdersText
  case content_ordersList

  // AddCoffeeTextFieldRowView
  case addCoffee_nameTextField
  case addCoffee_nameErrorText
  case addCoffee_coffeeNameTextField
  case addCoffee_coffeeNameErrorText
  case addCoffee_priceTextField
  case addCoffee_priceErrorText
  case addCoffee_placeOrderButton

  // OrderRowView
  case orderRow_deleteButton

  // OrderDetailView
  case orderDetail_coffeeNameText
  case orderDetail_deleteButton
  case orderDetail_editButton
}

extension View {
  func viewAccessibilityIdentifier(_ identifier: ViewAccessibilityIdentifier) -> some View {
    self.accessibilityIdentifier(identifier.rawValue)
  }
}
