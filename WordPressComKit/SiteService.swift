import Foundation
import Alamofire

extension Result {
    func map<T>(transform: Value -> T) -> Result<T, Error> {
        return flatMap({ .Success(transform($0)) })
    }

    func flatMap<T>(transform: Value -> Result<T, Error>) -> Result<T, Error> {
        switch self {
        case .Success(let value):
            return transform(value)
        case .Failure(let error):
            return .Failure(error)
        }
    }
}

// TODO: use a decent error
let jsonDecodeError = NSError(domain: "WordPressComKit", code: -1, userInfo: nil)

public typealias JSON = [String: AnyObject]

public protocol Requester {
    func requestJSON(request: NSURLRequest, completion: Result<JSON, NSError> -> Void)
}

struct AlamofireRequester: Requester {
    func requestJSON(request: NSURLRequest, completion: Result<JSON, NSError> -> Void) {
        Alamofire
            .request(request)
            .validate()
            .responseJSON { response in
                let result = response.result.flatMap({ result -> Result<JSON, NSError> in
                    guard let json = result as? JSON else {
                        return .Failure(jsonDecodeError)
                    }
                    return .Success(json)
                })
                completion(result)
        }
    }
}

public struct SiteService {
    let requester: Requester

    public init(requester: Requester = AlamofireRequester()) {
        self.requester = requester
    }

    public func fetchSite(siteID: Int) -> NSURLRequest {
        return RequestRouter.Site(siteID: siteID).URLRequest
    }

    public func fetchSite(siteID: Int, completion: Result<Site, NSError> -> Void) {
        let request = fetchSite(siteID)
        requester.requestJSON(request) { result in
            let site = result.map(self.mapJSONToSite)
            completion(site)
        }
    }

    public func fetchSites(showActiveOnly: Bool = true) -> NSURLRequest {
        return RequestRouter.Sites(showActiveOnly: showActiveOnly).URLRequest
    }

    public func fetchSites(showActiveOnly: Bool = true, completion: Result<[Site], NSError> -> Void) {
        let request = fetchSites(showActiveOnly)
        requester.requestJSON(request) { result in
            let sites = result.map(self.mapJSONToSites)
            completion(sites)
        }
    }

    func mapJSONToSites(json: [String: AnyObject]) -> [Site] {
        let sitesDictionary = json["sites"] as! [[String: AnyObject]]
        return sitesDictionary.map(mapJSONToSite)
    }
    
    func mapJSONToSite(json: [String: AnyObject]) -> Site {
        let site = Site()
        
        let rawIcon = json["icon"] as? NSDictionary
        
        site.ID = json["ID"] as! Int
        site.name = json["name"] as? String
        site.description = json["description"] as? String
        site.URL = NSURL(string: json["URL"] as! String)
        site.icon = rawIcon?["img"] as? String
        site.jetpack = json["jetpack"] as! Bool
        site.postCount = json["post_count"] as! Int
        site.subscribersCount = json["subscribers_count"] as! Int
        site.language = json["lang"] as! String
        site.visible = json["visible"] as! Bool
        site.isPrivate = json["is_private"] as! Bool
        
        let options = json["options"] as? [String: AnyObject]
        if let timeZoneName = options?["timezone"] as? String {
            site.timeZone = NSTimeZone(name: timeZoneName)
        }
        
        return site
    }
}