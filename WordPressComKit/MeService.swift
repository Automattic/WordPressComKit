//
//  MeService.swift
//  WordPressKit
//
//  Created by Aaron Douglas on 11/25/15.
//  Copyright © 2015 Automattic. All rights reserved.
//

import Foundation

public class MeService {
    private var urlSession: NSURLSession!
    
    public init() {
        urlSession = NSURLSession.sharedSession()
    }
    
    public init(urlSession: NSURLSession) {
        self.urlSession = urlSession
    }
    
    public func fetchMe(completion: (Me?, NSError?) -> Void) {
        let baseURL = NSURL(string: "https://public-api.wordpress.com/rest/v1.1/")!
        let url = NSURL(string: "me", relativeToURL: baseURL)!
        
        let urlRequest = NSMutableURLRequest(
            URL: url,
            cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0 * 1000)
        urlRequest.HTTPMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = urlSession.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            var json = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]
            
            guard json != nil else {
                completion(nil, NSError(domain: "com.automattic.WordPressKit", code: -1000, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Unexpected remote error preventing JSON parsing", comment: "JSON parsing error string")]))
                return
            }
            
            let me = Me()
            me.ID = json!["ID"] as! Int
            me.displayName = json!["display_name"] as? String
            me.username = json!["username"] as! String
            me.email = json!["email"] as? String
            me.primaryBlogID = json!["primaryBlogID"] as? Int
            
            
            completion(me, nil)
        }
        
        task.resume()
    }
}