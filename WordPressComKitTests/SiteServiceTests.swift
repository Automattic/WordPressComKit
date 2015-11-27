import XCTest
import WordPressComKit

class SiteServiceTests: XCTestCase {
    var mockURLSession: MockNSURLSession!
    var subject: SiteService!
    
    override func setUp() {
        super.setUp()
        
        mockURLSession = MockNSURLSession()
        subject = SiteService(urlSession: mockURLSession)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        subject = nil
    }
    
    func testFetchSite() {
        let jsonData = readFile("site")
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://public-api.wordpress.com/rest/v1.1/site/1234")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
        MockNSURLSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
        let expectation = self.expectationWithDescription("FetchMe")
        
        subject.fetchSite(1234) { site, error -> Void in
            expectation.fulfill()
            
            XCTAssertNotNil(site)
            XCTAssertNil(error)
            
            XCTAssertEqual(66592863, site!.ID)
            XCTAssertEqual("The Dangling Pointer", site!.name)
            XCTAssertEqual("Sh*t my brain says and forgets about", site!.description)
            XCTAssertEqual("http://astralbodi.es", site!.URL.absoluteString)
            XCTAssertEqual(false, site!.jetpack)
            XCTAssertEqual(179, site!.postCount)
            XCTAssertEqual(233, site!.subscribersCount)
            XCTAssertEqual("en", site!.language)
            XCTAssertEqual(true, site!.visible)
            XCTAssertEqual(false, site!.isPrivate)
            XCTAssertEqual(NSTimeZone(name: "America/Chicago"), site!.timeZone)
        }
        
        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testFetchSites() {
        let jsonData = readFile("sites")
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://public-api.wordpress.com/rest/v1.1/me/sites")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
        MockNSURLSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
        let expectation = self.expectationWithDescription("FetchMe")
        
        subject.fetchSites { sites, error -> Void in
            expectation.fulfill()
            
            XCTAssertNotNil(sites)
            XCTAssertNil(error)
            
            XCTAssertEqual(13, sites!.count)
        }
        
        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
}