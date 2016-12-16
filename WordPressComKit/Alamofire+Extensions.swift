import Foundation
import Alamofire


/// Alamofire.Manager Helper Methods
///
extension Alamofire.SessionManager
{
    public func encodedMultipartRequest(_ request: RequestRouter, completion: @escaping ((_ request: UploadRequest?, _ error: Error?) -> Void)) {
        upload(multipartFormData: { multipartFormData in
            request.loadMultipartFields(multipartFormData)
        }, with: request, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                completion(upload, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
}
