//
//  String+Extensions.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 09/12/2022.
//

import Foundation

extension String {
  var isNumeric: Bool {
    Double(self) != nil
  }

  func isLessThan(_ number: Double) -> Bool {
    if !self.isNumeric {
      return false
    }
    guard let value = Double(self) else { return false }
    return value < number
  }
}
