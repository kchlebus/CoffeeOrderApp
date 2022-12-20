//
//  CoffeeOrderAppE2ETests.swift
//  CoffeeOrderAppE2ETests
//
//  Created by Kamil Chlebuś on 08/12/2022.
//

import XCTest

let testLaunchEnvironment: [String: String] = [
  "ENV": "TEST",
  "DISABLE_ANIMATIONS": "1"
]

final class when_adding_a_new_coffee_order: XCTestCase {
  private var app: XCUIApplication!

  lazy var nameTextField = app.textFields[.addCoffee_nameTextField]
  lazy var coffeeTextField = app.textFields[.addCoffee_coffeeNameTextField]
  lazy var priceTextField = app.textFields[.addCoffee_priceTextField]
  lazy var placeOrderButton = app.buttons[.addCoffee_placeOrderButton]
  lazy var orderRowDeleteButton = app.buttons[.orderRow_deleteButton]
  lazy var contentOrdersList = app.collectionViews[.content_ordersList]
  lazy var orderDetailEditButton = app.buttons[.orderDetail_editButton]
  lazy var orderDetailCoffeeNameText = app.staticTexts[.orderDetail_coffeeNameText]

  override func setUp() {
    super.setUp()
    app = XCUIApplication()
    app.launchEnvironment = testLaunchEnvironment
    app.launch()
    app.buttons[.content_addOrderButton].tap()
  }

  override func tearDown() async throws {
    await deleteAllOrders()
  }

  func test_should_display_new_order_in_list_with_success() {
    // GIVEN
    let name = "Kamil"
    let coffeeName = "Cappuccino"
    let price = "3.5"

    // WHEN
    addNewOrder(name: name, coffeeName: coffeeName, price: price)

    // THAN
    let orderRow = getOrderRow(by: name, coffeeName: coffeeName, price: price)
    _ = orderRow.waitForExistence(timeout: 1.0)
    XCTAssertTrue(orderRow.exists)
  }

  func test_should_delete_recently_added_order() {
    // GIVEN
    let name = "Ben"
    let coffeeName = "Espresso"
    let price = "1.2"
    addNewOrder(name: name, coffeeName: coffeeName, price: price)
    let ordersCountBefore = contentOrdersList.tableRows.count

    // WHEN
    let orderRow = getOrderRow(by: name, coffeeName: coffeeName, price: price)
    orderRow.swipeLeft()
    orderRowDeleteButton.tap()
    let ordersCountAfter = contentOrdersList.tableRows.count

    // THEN
    XCTAssertEqual(ordersCountBefore, ordersCountAfter)
  }

  func test_should_validate_not_empty_fields() {
    // GIVEN
    let nameErrorText = app.staticTexts[.addCoffee_nameErrorText]
    let coffeeNameErrorText = app.staticTexts[.addCoffee_coffeeNameErrorText]
    let priceErrorText = app.staticTexts[.addCoffee_priceErrorText]

    // WHEN
    nameTextField.tap()
    nameTextField.typeText("")

    coffeeTextField.tap()
    coffeeTextField.typeText("")

    priceTextField.tap()
    priceTextField.typeText("")

    placeOrderButton.tap()

    // THAN
    XCTAssertTrue(nameErrorText.exists)
    XCTAssertTrue(coffeeNameErrorText.exists)
    XCTAssertTrue(priceErrorText.exists)

    XCTAssertNotEqual(nameErrorText.label, "")
    XCTAssertNotEqual(coffeeNameErrorText.label, "")
    XCTAssertNotEqual(priceErrorText.label, "")
  }

  func test_should_update_order_with_success() {
    // GIVEN
    let name = "John"
    let coffeeName = "Americano"
    let price = "4.5"
    let updateCoffee = "Americano Double"

    // WHEN
    addNewOrder(name: name, coffeeName: coffeeName, price: price)

    let orderRow = getOrderRow(by: name, coffeeName: coffeeName, price: price)
    _ = orderRow.waitForExistence(timeout: 2.0)
    orderRow.tap()

    orderDetailEditButton.tap()
    coffeeTextField.doubleTap()
    coffeeTextField.typeText(updateCoffee)
    placeOrderButton.tap()
    _ = orderDetailCoffeeNameText.waitForExistence(timeout: 1.0)

    // THEN
    XCTAssertEqual(orderDetailCoffeeNameText.label, updateCoffee)
  }
}

extension when_adding_a_new_coffee_order {
  func addNewOrder(name: String, coffeeName: String, price: String) {
    nameTextField.tap()
    nameTextField.typeText(name)

    coffeeTextField.tap()
    coffeeTextField.typeText(coffeeName)

    priceTextField.tap()
    priceTextField.typeText(price)

    placeOrderButton.tap()
  }

  func deleteAllOrders() async {
    guard let url =  URL(
      string: "/test/clear-orders",
      relativeTo: URL(string: "https://island-bramble.glitch.me")!
    ) else {
      return
    }
    let (_, _) = try! await URLSession.shared.data(from: url)
  }

  func getOrderRow(by name: String, coffeeName: String, price: String) -> XCUIElement {
    contentOrdersList.cells
      .containing(NSPredicate(format: "label CONTAINS %@", name))
      .containing(NSPredicate(format: "label CONTAINS %@", coffeeName))
      .containing(NSPredicate(format: "label CONTAINS %@", price))
      .element
  }
}

final class when_app_is_launched_with_no_orders: XCTestCase {
  private var app: XCUIApplication!

  override func setUp() {
    super.setUp()
    app = XCUIApplication()
    app.launchEnvironment = testLaunchEnvironment
    app.launch()
  }

  func test_should_make_sure_no_orders_message_is_displayed() {
    XCTAssertEqual("No orders available!", app.staticTexts[.content_noOrdersText].label)
  }
}
