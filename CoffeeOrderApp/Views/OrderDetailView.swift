//
//  OrderDetailView.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 15/12/2022.
//

import SwiftUI

struct OrderDetailView: View {
  @EnvironmentObject private var store: CoffeeStore
  @Environment(\.dismiss) private var dismiss
  @State private var isPresented: Bool = false
  @State var order: Order

  var body: some View {
    VStack {
      VStack(alignment: .leading, spacing: 10) {
        coffeeInfoView
        buttonsView
      }
      .sheet(isPresented: $isPresented) {
        AddCoffeeView(existingOrder: Binding<Order?>($order))
      }
      Spacer()
    }
    .padding()
  }

  @ViewBuilder
  var coffeeInfoView: some View {
    Text(order.coffeeName)
      .font(.title)
      .frame(maxWidth: .infinity, alignment: .leading)
      .viewAccessibilityIdentifier(.orderDetail_coffeeNameText)
    Text(order.size.rawValue)
      .opacity(0.5)
    Text(order.total as NSNumber, formatter: NumberFormatter.currency)
  }

  var buttonsView: some View {
    HStack {
      Spacer()
      Button("Delete order", role: .destructive) {
        guard let id = order.id else { return }
        Task {
          await deleteOrder(orderId: id)
          dismiss()
        }
      }
      .viewAccessibilityIdentifier(.orderDetail_deleteButton)
      Button("Edit order") {
        isPresented = true
      }
      .viewAccessibilityIdentifier(.orderDetail_editButton)
      Spacer()
    }
  }
}

private extension OrderDetailView {
  func deleteOrder(orderId: Int) async {
    do {
      try await store.deleteOrder(id: orderId)
    } catch {
      print(error)
    }
  }
}

#if !TESTING
struct OrderDetailView_Previews: PreviewProvider {
  static var previews: some View {
    OrderDetailView(order: Order(id: 1, name: "Test", coffeeName: "Espresso", total: 1.2, size: .small))
      .environmentObject(CoffeeStore())
  }
}
#endif
