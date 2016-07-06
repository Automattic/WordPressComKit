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

    func testCreateMediaFromImageInstance() {
        let siteID = 123
        let mediaSize = CGSize(width: 3000, height: 2002)
        let remoteURL = "https://lanteanartest.files.wordpress.com/2016/06/img_00035.jpg"

        stub(isMethodPOST() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/sites/\(siteID)/media/new")) { _ in
            let stubPath = OHPathForFile("media.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type": "application/json"])
        }

        let expectation = self.expectationWithDescription("CreateMedia")

        let imageURL = NSBundle(forClass: self.dynamicType).URLForResource("wordpress-logo", withExtension: "png")
        XCTAssertNotNil(imageURL)

        let imageData = NSData(contentsOfURL: imageURL!)
        XCTAssertNotNil(imageData)

        let rawImage = UIImage(data: imageData!)
        XCTAssertNotNil(rawImage)

        let attachedImagePNG = UIImagePNGRepresentation(rawImage!)
        XCTAssertNotNil(attachedImagePNG)

        subject.createMedia(attachedImagePNG!, siteID: siteID) { (media, error) in
            XCTAssertNotNil(media)
            XCTAssertEqual(media?.mediaID, siteID)
            XCTAssertEqual(media?.remoteURL, remoteURL)
            XCTAssertEqual(media?.size, mediaSize)
            XCTAssertNil(error)

            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
}
