import Foundation

public class Post {
    public var ID: Int?
    public var siteID: Int!
    public var created: NSDate!
    public var updated: NSDate?
    public var title: String?
    public var URL: NSURL?
    public var shortURL: NSURL?
    public var content: String?
    public var guid: String?
    public var status: String?
    public var featuredImageURL: NSURL?
}