//
//  VehiclesSceneUITests.swift
//  RidesUITests
//
//  Created by Sameh Farouk on 01/09/2023.
//

import XCTest

class VehiclesSceneUITests: XCTestCase {

    override func setUp() {

        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testOpenVehicleDetails_whenSearchOneAndTapOnFirstResultRow_thenVehicleDetailsViewOpens() {
        
        let app = XCUIApplication()
        
        let searchText = "1"
        app.textFields[AccessibilityIdentifier.searchField].tap()
        _ = app.textFields[AccessibilityIdentifier.searchField].waitForExistence(timeout: 10)
        app.textFields[AccessibilityIdentifier.searchField].typeText(searchText)
        app.buttons["Search"].tap()
        sleep(10)
        
        // Tap on first result row
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)
        firstCell.tap()
        
        // Make sure vechile details view
        XCTAssertTrue(app.otherElements[AccessibilityIdentifier.vehicleDetailsView].waitForExistence(timeout: 5))
    }
}
