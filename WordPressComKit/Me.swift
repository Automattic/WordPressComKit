import Foundation

public class Me {
    var ID: Int!
    var displayName: String?
    var username: String!
    var email: String?
    var primaryBlogID: Int?
    var primaryBlogURL: NSURL?
    var language = "en"
    var avatarURL: NSURL?
    var profileURL: NSURL?
    var verified = true
    var emailVerified = true
    var dateCreated: NSDate?
    var siteCount = 0
    var visibleSiteCount = 0
    var hasUnseenNotes = false
    var newestNoteType: String?
    var phoneAccount = false
}