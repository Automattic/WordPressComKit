import XCTest
@testable import WordPressComKit

class SiteServiceTests: XCTestCase {
    let subject = SiteService()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchSite() {
        let request = subject.fetchSite(1234)
        XCTAssertEqual("public-api.wordpress.com", request.URL?.host)
        XCTAssertEqual("/rest/v1.1/sites/1234", request.URL?.path)

        let json = loadJSONFile("site")
        let site = subject.mapJSONToSite(json)

        XCTAssertEqual(66592863, site.ID)
        XCTAssertEqual("The Dangling Pointer", site.name)
        XCTAssertEqual("Sh*t my brain says and forgets about", site.description)
        XCTAssertEqual("http://astralbodi.es", site.URL.absoluteString)
        XCTAssertEqual("https://secure.gravatar.com/blavatar/6f0ad402b5cbfe40cef23c63488742a7", site.icon)
        XCTAssertEqual(false, site.jetpack)
        XCTAssertEqual(179, site.postCount)
        XCTAssertEqual(233, site.subscribersCount)
        XCTAssertEqual("en", site.language)
        XCTAssertEqual(true, site.visible)
        XCTAssertEqual(false, site.isPrivate)
        XCTAssertEqual(NSTimeZone(name: "America/Chicago"), site.timeZone)
    }
    
    func testFetchSites() {
        let request = subject.fetchSites()
        XCTAssertEqual("public-api.wordpress.com", request.URL?.host)
        XCTAssertEqual("/rest/v1.1/me/sites", request.URL?.path)

        let json = loadJSONFile("sites")
        let sites = subject.mapJSONToSites(json)
        XCTAssertEqual(13, sites.count)
    }
    
    private func loadJSONFile(name: String) -> JSON {
        let bundle = NSBundle(forClass: self.dynamicType)
        let path = bundle.pathForResource(name, ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let json = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as! JSON
        return json
    }
    
}