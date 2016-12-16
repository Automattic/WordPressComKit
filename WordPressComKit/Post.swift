import Foundation

open class Post {
    open var ID: Int?
    open var siteID: Int!
    open var created: Date!
    open var updated: Date?
    open var title: String?
    open var URL: Foundation.URL?
    open var shortURL: Foundation.URL?
    open var content: String?
    open var guid: String?
    open var status: String?
    open var featuredImageURL: Foundation.URL?
}
