import XCTest
import OHHTTPStubs
import WordPressComKit

class MeServiceTests: XCTestCase {
    var subject: MeService!
    
    override func setUp() {
        super.setUp()
        
        subject = MeService()
    }
    
    override func tearDown() {
        super.tearDown()
        
        subject = nil
        OHHTTPStubs.removeAllStubs()
    }
    
    func testFetchMe() {
        stub(isMethodGET() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/me")) { _ in
            let stubPath = OHPathForFile("me.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type": "application/json"])
        }

        let expectation = self.expectationWithDescription("FetchMe")
        
        subject.fetchMe { me, error -> Void in
            expectation.fulfill()
            XCTAssertNotNil(me)
            XCTAssertNil(error)
        }
        
        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testFetchMe2() {
        stub(isMethodGET() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/me")) { _ in
            let stubPath = OHPathForFile("me-2.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectationWithDescription("FetchMe")
        
        subject.fetchMe { me, error -> Void in
            expectation.fulfill()
            XCTAssertNotNil(me)
            XCTAssertNil(error)
        }
        
        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
}
