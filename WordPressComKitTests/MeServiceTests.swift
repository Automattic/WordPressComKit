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
        stub(condition: isMethodGET() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/me")) { _ in
            let stubPath = OHPathForFile("me.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject: "application/json" as AnyObject])
        }

        let expectation = self.expectation(description: "FetchMe")
        
        subject.fetchMe { me, error -> Void in
            expectation.fulfill()
            XCTAssertNotNil(me)
            XCTAssertNil(error)
        }
        
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchMe2() {
        stub(condition: isMethodGET() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/me")) { _ in
            let stubPath = OHPathForFile("me-2.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject: "application/json" as AnyObject])
        }
        
        let expectation = self.expectation(description: "FetchMe")
        
        subject.fetchMe { me, error -> Void in
            expectation.fulfill()
            XCTAssertNotNil(me)
            XCTAssertNil(error)
        }
        
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    
}
