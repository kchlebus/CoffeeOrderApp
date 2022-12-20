//
//  NumberFormatter+Extensions.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 08/12/2022.
//

import Foundation

extension NumberFormatter {
  static var currency: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()
}
