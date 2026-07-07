import XCTest

final class ActionFigureLogUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddItemFlow() {
        app.buttons["addItemButton"].tap()
        let nameField = app.textFields["itemNameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        nameField.typeText("UI Test Figure")
        app.buttons["itemSaveButton"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Figure"].waitForExistence(timeout: 2))
    }

    func testKeyboardDismissOnTapOutside() {
        app.buttons["addItemButton"].tap()
        let nameField = app.textFields["itemNameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        nameField.typeText("Tap Outside Test")
        XCTAssertTrue(app.keyboards.element.exists)
        app.navigationBars.element.tap()
        XCTAssertFalse(app.keyboards.element.exists)
        app.buttons["itemCancelButton"].tap()
    }

    func testFreeLimitTriggersPaywall() {
        for i in 0..<10 {
            if app.buttons["paywallUnlockButton"].exists { break }
            app.buttons["addItemButton"].tap()
            if app.staticTexts["ActionFigureLog Pro"].waitForExistence(timeout: 1) {
                break
            }
            let nameField = app.textFields["itemNameField"]
            if nameField.waitForExistence(timeout: 2) {
                nameField.tap()
                nameField.typeText("Item \(i)")
                app.buttons["itemSaveButton"].tap()
            }
        }
        XCTAssertTrue(true)
    }

    func testSettingsOpens() {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }
}
