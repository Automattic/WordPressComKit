import XCTest
import WordPressComKit

class DateHelpersTests: XCTestCase {
    func testConvert() {
        let date = convertUTCWordPressComDate("2006-01-13T18:04:27+00:00")
        
        XCTAssertNotNil(date)
        
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
        
        XCTAssertEqual(2006, dateComponents.year)
        XCTAssertEqual(1, dateComponents.month)
        XCTAssertEqual(13, dateComponents.day)
        XCTAssertEqual(18, dateComponents.hour)
        XCTAssertEqual(4, dateComponents.minute)
        XCTAssertEqual(27, dateComponents.second)
    }
}
