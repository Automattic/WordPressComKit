import Foundation

open class Me {
    var ID: Int!
    var displayName: String?
    var username: String!
    var email: String?
    var primaryBlogID: Int?
    var primaryBlogURL: URL?
    var language: String?
    var avatarURL: URL?
    var profileURL: URL?
    var verified = true
    var emailVerified = true
    var dateCreated: Date?
    var siteCount = 0
    var visibleSiteCount = 0
    var hasUnseenNotes = false
    var newestNoteType: String?
    var phoneAccount = false
}
