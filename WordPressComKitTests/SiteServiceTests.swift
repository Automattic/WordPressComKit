import XCTest
import OHHTTPStubs
import WordPressComKit

class SiteServiceTests: XCTestCase {
    var subject: SiteService!
    
    override func setUp() {
        super.setUp()
        
        subject = SiteService()
    }
    
    override func tearDown() {
        super.tearDown()
        
        subject = nil
        OHHTTPStubs.removeAllStubs()
    }
    
    func testFetchSite() {
        stub(isMethodGET() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/sites/1234")) { _ in
            let stubPath = OHPathForFile("site.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectationWithDescription("FetchMe")
        
        subject.fetchSite(1234) { site, error -> Void in
            expectation.fulfill()
            
            XCTAssertNotNil(site)
            XCTAssertNil(error)
            
            XCTAssertEqual(66592863, site!.ID)
            XCTAssertEqual("The Dangling Pointer", site!.name)
            XCTAssertEqual("Sh*t my brain says and forgets about", site!.description)
            XCTAssertEqual("http://astralbodi.es", site!.URL.absoluteString)
            XCTAssertEqual("https://secure.gravatar.com/blavatar/6f0ad402b5cbfe40cef23c63488742a7", site!.icon)
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
    
    func testFetchSiteHTTP500Error() {
        stub(isMethodGET() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/sites/1234")) { _ in
            let stubPath = OHPathForFile("site.json", self.dynamicType)
            return fixture(stubPath!, status: 500, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectationWithDescription("FetchMe")
        
        subject.fetchSite(1234) { site, error -> Void in
            expectation.fulfill()
            
            XCTAssertNil(site)
            XCTAssertNotNil(error)
        }
        
        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testFetchSites() {
        stub(isMethodGET() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/me/sites")) { _ in
            let stubPath = OHPathForFile("sites.json", self.dynamicType)
            return fixture(stubPath!, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectationWithDescription("FetchMe")
        
        subject.fetchSites { sites, error -> Void in
            expectation.fulfill()
            
            XCTAssertNotNil(sites)
            XCTAssertNil(error)
            
            XCTAssertEqual(13, sites!.count)
        }
        
        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testFetchSitesHTTP500Error() {
        stub(isMethodGET() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/me/sites")) { _ in
            let stubPath = OHPathForFile("sites.json", self.dynamicType)
            return fixture(stubPath!, status: 500, headers: ["Content-Type": "application/json"])
        }
        
        let expectation = self.expectationWithDescription("FetchMe")
        
        subject.fetchSites { sites, error -> Void in
            expectation.fulfill()
            
            XCTAssertNil(sites)
            XCTAssertNotNil(error)
        }
        
        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    

    
}