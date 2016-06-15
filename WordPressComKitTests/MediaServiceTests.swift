import XCTest
import OHHTTPStubs
import WordPressComKit

class MediaServiceTests: XCTestCase {
    var subject: MediaService!

    override func setUp() {
        super.setUp()

        subject = MediaService()
    }

    override func tearDown() {
        super.tearDown()

        subject = nil
        OHHTTPStubs.removeAllStubs()
    }

    func testCreateMedia() {
        let siteID = 123

        stub(isMethodPOST() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/sites/\(siteID)/media/new")) { _ in
            let stubPath = OHPathForFile("media.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type": "application/json"])
        }

        let expectation = self.expectationWithDescription("CreateMedia")

        let imageURL = NSBundle(forClass: self.dynamicType).URLForResource("wordpress-logo", withExtension: "png")
        XCTAssertNotNil(imageURL)

        subject.createMedia(imageURL!, siteID: siteID) { (media, error) in
            XCTAssertNotNil(media)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
}
