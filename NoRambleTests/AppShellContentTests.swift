import XCTest
@testable import NoRamble

final class AppShellContentTests: XCTestCase {
    func testDefaultContent_identifiesNoRambleAndFoundationReadiness() {
        let content = AppShellContent.foundation

        XCTAssertEqual(content.title, "No Ramble")
        XCTAssertEqual(content.status, "Ready for the first daily practice slice")
    }
}
