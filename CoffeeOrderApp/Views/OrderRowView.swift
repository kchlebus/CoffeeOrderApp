//
//  OrderRowView.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 08/12/2022.
//

import SwiftUI

struct OrderRowView: View {
  let order: Order

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(order.name)
          .bold()
        Text("\(order.coffeeName) (\(order.size.rawValue))")
          .opacity(0.5)
      }
      Spacer()
      Text(order.total as NSNumber, formatter: NumberFormatter.currency)
    }
  }
}

#if !TESTING
struct OrderRowView_Previews: PreviewProvider {
  static var previews: some View {
    OrderRowView(order: Order.preview)
      .previewLayout(.sizeThatFits)
  }
}
#endif
