import Foundation

public struct StatsLatestPostSummary {
    public let postID: Int
    public let postTitle: String
    public let postAge: String
    public let postURL: NSURL
    
    public let views: LocalizableValue<Int>
    public let likes: LocalizableValue<Int>
    public let comments: LocalizableValue<Int>
}