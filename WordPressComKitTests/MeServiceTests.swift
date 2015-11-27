import XCTest
import WordPressComKit

class MeServiceTests: XCTestCase {
    var mockURLSession: MockNSURLSession!
    var subject: MeService!
    
    override func setUp() {
        super.setUp()
        
        mockURLSession = MockNSURLSession()
        subject = MeService(urlSession: mockURLSession)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        subject = nil
    }
    
    func testFetchMe() {
        let jsonData = readFile("me")
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://public-api.wordpress.com/rest/v1.1/me")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
        MockNSURLSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
        let expectation = self.expectationWithDescription("FetchMe")
        
        subject.fetchMe { me, error -> Void in
            expectation.fulfill()
            XCTAssertNotNil(me)
            XCTAssertNil(error)
        }
        
        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testFetchMe2() {
        let jsonData = readFile("me-2")
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://public-api.wordpress.com/rest/v1.1/me")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
        MockNSURLSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
        let expectation = self.expectationWithDescription("FetchMe")
        
        subject.fetchMe { me, error -> Void in
            expectation.fulfill()
            XCTAssertNotNil(me)
            XCTAssertNil(error)
        }
        
        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
}
