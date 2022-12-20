//
//  ContentView.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 07/12/2022.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject private var store: CoffeeStore
  @State private var isAddCoffeePresented: Bool = false
  @State private var isLoadingOrders: Bool = false

  var body: some View {
    NavigationStack {
      VStack {
        if isLoadingOrders {
          ProgressView()
        } else {
          if store.orders.isEmpty {
            Text("No orders available!")
              .viewAccessibilityIdentifier(.content_noOrdersText)
          } else {
            ordersListView
          }
        }
      }
      .navigationDestination(for: Order.self, destination: { order in
        OrderDetailView(order: order)
      })
      .task {
        isLoadingOrders = true
        await populateOrders()
        isLoadingOrders = false
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          toolbarAddOrderButton
        }
      }
      .sheet(isPresented: $isAddCoffeePresented) {
        AddCoffeeView(existingOrder: .constant(nil))
      }
    }
  }

  var ordersListView: some View {
    List(store.orders) { order in
      NavigationLink(value: order) {
        OrderRowView(order: order)
          .swipeActions {
            Button(role: .destructive, action: {
              guard let id = order.id else { return }
              Task {
                await deleteOrder(id: id)
              }
            }) {
              Image(systemName: "trash.fill")
            }
            .viewAccessibilityIdentifier(.orderRow_deleteButton)
          }
      }
    }
    .viewAccessibilityIdentifier(.content_ordersList)
  }

  var toolbarAddOrderButton: some View {
    Button {
      isAddCoffeePresented = true
    } label: {
      Image(systemName: "plus.circle.fill")
        .resizable()
        .scaledToFill()
    }
    .frame(width: 50, height: 50)
    .foregroundColor(Color.red)
    .viewAccessibilityIdentifier(.content_addOrderButton)
  }
}

private extension ContentView {
  func populateOrders() async {
    do {
      try await store.fetchOrders()
    } catch {
      debugPrint(error)
    }
  }

  func deleteOrder(id: Int) async {
    do {
      try await store.deleteOrder(id: id)
    } catch {
      debugPrint(error)
    }
  }
}

#if !TESTING
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(CoffeeStore())
  }
}
#endif
