import XCTest
import WordPressComKit

class PostServiceTests: XCTestCase {
    var mockURLSession: MockNSURLSession!
    var subject: PostService!
    
    override func setUp() {
        super.setUp()
        
        mockURLSession = MockNSURLSession()
        subject = PostService(urlSession: mockURLSession)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        subject = nil
    }
    
    func testFetchSite() {
        let jsonData = readFile("post")
        let urlResponse = NSHTTPURLResponse(URL: NSURL(string: "https://public-api.wordpress.com/rest/v1.1/site/57773116/post/57")!, statusCode: 200, HTTPVersion: nil, headerFields: nil)
        MockNSURLSession.mockResponse = (jsonData, urlResponse: urlResponse, error: nil)
        let expectation = self.expectationWithDescription("FetchMe")
        
        subject.fetchPost(57, siteID: 57773116) { (post, error) -> Void in
            expectation.fulfill()
            
            XCTAssertNotNil(post)
            XCTAssertNil(error)
            
            XCTAssertEqual(57, post!.ID)
            XCTAssertEqual(57773116, post!.siteID)
            XCTAssertNotNil(post!.created)
            XCTAssertNotNil(post!.updated)
            XCTAssertEqual("Test post from the REST API", post!.title)
            XCTAssertEqual("https://ardwptest1.wordpress.com/2015/11/27/test-post-from-the-rest-api/", post!.URL?.absoluteString)
            XCTAssertEqual("http://wp.me/p3Upqs-V", post!.shortURL?.absoluteString)
            XCTAssertEqual("<p>And this is the content of the post.</p>\n", post!.content)
            XCTAssertEqual("https://ardwptest1.wordpress.com/2015/11/27/test-post-from-the-rest-api/", post!.guid)
            XCTAssertEqual("publish", post!.status)
            XCTAssertNil(post!.featuredImageURL)
        }
        
        self.waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
}
