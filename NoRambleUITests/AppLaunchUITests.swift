import XCTest

@MainActor
final class AppLaunchUITests: XCTestCase {
    func testLaunch_displaysAccessibleAppShell() {
        let app = XCUIApplication()
        app.launch()

        let title = app.staticTexts["app-shell-title"]
        let status = app.staticTexts["app-shell-status"]

        XCTAssertTrue(title.waitForExistence(timeout: 5))
        XCTAssertEqual(title.label, "No Ramble")
        XCTAssertTrue(status.exists)
        XCTAssertEqual(status.label, "Ready for the first daily practice slice")
    }
}
