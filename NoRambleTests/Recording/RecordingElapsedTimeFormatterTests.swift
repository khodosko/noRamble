import XCTest
@testable import NoRamble

final class RecordingElapsedTimeFormatterTests: XCTestCase {
    func testString_clampsNegativeIntervalsAndUsesMinuteSecondFormat() {
        XCTAssertEqual(RecordingElapsedTimeFormatter.string(for: -1), "0:00")
        XCTAssertEqual(RecordingElapsedTimeFormatter.string(for: 0), "0:00")
        XCTAssertEqual(RecordingElapsedTimeFormatter.string(for: 9), "0:09")
        XCTAssertEqual(RecordingElapsedTimeFormatter.string(for: 59), "0:59")
        XCTAssertEqual(RecordingElapsedTimeFormatter.string(for: 60), "1:00")
        XCTAssertEqual(RecordingElapsedTimeFormatter.string(for: 125), "2:05")
    }
}
