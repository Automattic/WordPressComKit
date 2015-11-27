import XCTest
import WordPressComKit

class DateHelpersTests: XCTestCase {
    func testConvert() {
        let date = convertUTCWordPressComDate("2006-01-13T18:04:27+00:00")
        
        XCTAssertNotNil(date)
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = NSTimeZone(name: "UTC")!
        let dateComponents = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date!)
        
        XCTAssertEqual(2006, dateComponents.year)
        XCTAssertEqual(1, dateComponents.month)
        XCTAssertEqual(13, dateComponents.day)
        XCTAssertEqual(18, dateComponents.hour)
        XCTAssertEqual(4, dateComponents.minute)
        XCTAssertEqual(27, dateComponents.second)
    }
}
