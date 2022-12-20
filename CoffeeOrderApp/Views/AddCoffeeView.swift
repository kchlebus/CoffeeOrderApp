//
//  AddCoffeeView.swift
//  CoffeeOrderApp
//
//  Created by Kamil Chlebuś on 08/12/2022.
//

import SwiftUI

struct AddCoffeeErrors {
  var name: String = ""
  var coffeeName: String = ""
  var price: String = ""
}

struct AddCoffeeView: View {
  @State private var name: String = ""
  @State private var coffeeName: String = ""
  @State private var price: String = ""
  @State private var coffeeSize: CoffeeSize = .medium

  @State private var errors: AddCoffeeErrors = AddCoffeeErrors()

  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var coffeeStore: CoffeeStore
  @Binding var existingOrder: Order?

  var body: some View {
    NavigationStack {
      Form {
        // NAME
        TextField("Name", text: $name)
          .viewAccessibilityIdentifier( .addCoffee_nameTextField)
        Text(errors.name)
          .font(.caption)
          .visible(!errors.coffeeName.isEmpty)
          .viewAccessibilityIdentifier(.addCoffee_nameErrorText)

        // COFFEE NAME
        TextField("Coffee name", text: $coffeeName)
          .viewAccessibilityIdentifier( .addCoffee_coffeeNameTextField)
        Text(errors.coffeeName)
          .font(.caption)
          .visible(!errors.coffeeName.isEmpty)
          .viewAccessibilityIdentifier(.addCoffee_coffeeNameErrorText)

        // PRICE
        TextField("Price", text: $price)
          .viewAccessibilityIdentifier( .addCoffee_priceTextField)
        Text(errors.price)
          .font(.caption)
          .visible(!errors.price.isEmpty)
          .viewAccessibilityIdentifier(.addCoffee_priceErrorText)

        // COFFEE SIZE
        Picker("Select size", selection: $coffeeSize) {
          ForEach(CoffeeSize.allCases, id: \.rawValue) { size in
            Text(size.rawValue)
              .tag(size)
          }
        }
        .pickerStyle(.segmented)

        // SUBMIT
        Button(existingOrder == nil ? "Place order" : "Update order") {
          if isValid {
            Task {
              await createOrUpdateOrder()
              dismiss()
            }
          }
        }
        .centerHorizontally()
        .viewAccessibilityIdentifier(.addCoffee_placeOrderButton)
      }
      .navigationTitle(existingOrder == nil ? "Add Coffee" : "Update coffee")
      .onAppear {
        if let existingOrder {
          name = existingOrder.name
          coffeeName = existingOrder.coffeeName
          price = "\(existingOrder.total)"
          coffeeSize = existingOrder.size
        }
      }
    }
  }
}

private extension AddCoffeeView {
  var isValid: Bool {
    errors = AddCoffeeErrors()

    if name.isEmpty {
      errors.name = "Name cannot be empty!"
    }
    if coffeeName.isEmpty {
      errors.coffeeName = "Coffee name cannot be empty"
    }
    if price.isEmpty {
      errors.price = "Price cannot be empty"
    } else if !price.isNumeric {
      errors.price = "Price needs to be a number"
    } else if price.isLessThan(1) {
      errors.price = "Price needs to be more than 0"
    }

    return errors.name.isEmpty && errors.coffeeName.isEmpty && errors.price.isEmpty
  }

  func createOrUpdateOrder() async {
    if let existingOrder {
      var order = existingOrder
      order.name = name
      order.coffeeName = coffeeName
      order.total = Double(price) ?? 0.0
      order.size = coffeeSize
      await updateOrder(order)
      self.existingOrder = order
    } else {
      let order = Order(
        name: name,
        coffeeName: coffeeName,
        total: Double(price) ?? 0.0,
        size: coffeeSize
      )
      await createOrder(order)
    }
  }

  func createOrder(_ order: Order) async {
    do {
      try await coffeeStore.createOrder(order)
    } catch {
      print(error)
    }
  }

  func updateOrder(_ order: Order) async {
    do {
      try await coffeeStore.updateOrder(order)
    } catch {
      print(error)
    }
  }
}

#if !TESTING
struct AddCoffeeView_Previews: PreviewProvider {
  static var previews: some View {
    AddCoffeeView(existingOrder: .constant(nil))
  }
}
#endif
