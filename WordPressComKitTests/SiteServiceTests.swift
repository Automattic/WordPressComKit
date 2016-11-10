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
        stub(condition: isMethodGET() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/sites/1234")) { _ in
            let stubPath = OHPathForFile("site.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject: "application/json" as AnyObject])
        }
        
        let expectation = self.expectation(description: "FetchMe")
        
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
            XCTAssertEqual(TimeZone(identifier: "America/Chicago"), site!.timeZone)
        }
        
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchSiteHTTP500Error() {
        stub(condition: isMethodGET() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/sites/1234")) { _ in
            let stubPath = OHPathForFile("site.json", type(of: self))
            return fixture(filePath: stubPath!, status: 500, headers: ["Content-Type" as NSObject: "application/json" as AnyObject])
        }
        
        let expectation = self.expectation(description: "FetchMe")
        
        subject.fetchSite(1234) { site, error -> Void in
            expectation.fulfill()
            
            XCTAssertNil(site)
            XCTAssertNotNil(error)
        }
        
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchSites() {
        stub(condition: isMethodGET() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/me/sites")) { _ in
            let stubPath = OHPathForFile("sites.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject: "application/json" as AnyObject])
        }
        
        let expectation = self.expectation(description: "FetchMe")
        
        subject.fetchSites { sites, error -> Void in
            expectation.fulfill()
            
            XCTAssertNotNil(sites)
            XCTAssertNil(error)
            
            XCTAssertEqual(13, sites!.count)
        }
        
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchSitesHTTP500Error() {
        stub(condition: isMethodGET() && isHost("public-api.wordpress.com") && isPath("/rest/v1.1/me/sites")) { _ in
            let stubPath = OHPathForFile("sites.json", type(of: self))
            return fixture(filePath: stubPath!, status: 500, headers: ["Content-Type" as NSObject: "application/json" as AnyObject])
        }
        
        let expectation = self.expectation(description: "FetchMe")
        
        subject.fetchSites { sites, error -> Void in
            expectation.fulfill()
            
            XCTAssertNil(sites)
            XCTAssertNotNil(error)
        }
        
        self.waitForExpectations(timeout: 2.0, handler: nil)
    }
    

    
}
