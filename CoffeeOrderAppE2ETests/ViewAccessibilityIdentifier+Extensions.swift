//
//  ViewAccessibilityIdentifier+Extensions.swift
//  CoffeeOrderAppE2ETests
//
//  Created by Kamil Chlebuś on 12/12/2022.
//

import XCTest

extension XCUIElementQuery {
  subscript(key: ViewAccessibilityIdentifier) -> XCUIElement {
    self[key.rawValue]
  }
}
