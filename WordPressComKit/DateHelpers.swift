import Foundation

public func convertUTCWordPressComDate(dateString: String) -> NSDate? {
    let dateFormatter = NSDateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.timeZone = NSTimeZone(name: "UTC")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    return dateFormatter.dateFromString(dateString)
}