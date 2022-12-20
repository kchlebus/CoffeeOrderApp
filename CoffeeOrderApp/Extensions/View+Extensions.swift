//
//  View+Extensions.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 09/12/2022.
//

import SwiftUI

extension View {
  func centerHorizontally() -> some View {
    VStack(alignment: .center) {
      self
    }
    .frame(maxWidth: .infinity)
  }

  @ViewBuilder
  func visible(_ value: Bool) -> some View {
    switch value {
    case true:
      self
    case false:
      EmptyView()
    }
  }
}
