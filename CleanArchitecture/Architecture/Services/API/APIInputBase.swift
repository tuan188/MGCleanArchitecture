import Alamofire

class APIInputBase: Then {
    var headers: [String: String] = [:]
    let urlString: String
    let requestType: HTTPMethod
    let encoding: ParameterEncoding
    let parameters: [String: Any]?
    let requireAccessToken: Bool
    var accessToken: String?
    var useCache: Bool = false {
        didSet {
            if requestType == .get || self is APIUploadInputBase {
                fatalError()
            }
        }
    }
    var user: String?
    var password: String?
    
    init(urlString: String,
         parameters: [String: Any]?,
         requestType: HTTPMethod,
         requireAccessToken: Bool) {
        self.urlString = urlString
        self.parameters = parameters
        self.requestType = requestType
        self.encoding = requestType == .get ? URLEncoding.default : JSONEncoding.default
        self.requireAccessToken = requireAccessToken
    }
}


extension APIInputBase: CustomStringConvertible {
    var urlEncodingString: String {
        guard
            let url = URL(string: urlString),
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let parameters = parameters,
            requestType == .get
            else {
                return urlString
        }
        urlComponents.queryItems = parameters.map {
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        return urlComponents.url?.absoluteString ?? urlString
    }
    
    var description: String {
        if requestType == .get {
            return [
                "🌎 \(requestType.rawValue) \(urlEncodingString)"
                ].joined(separator: "\n")
        }
        return [
            "🌎 \(requestType.rawValue) \(urlString)",
            "Parameters: \(String(describing: parameters ?? JSONDictionary()))"
            ].joined(separator: "\n")
    }
}

struct APIUploadData {
    let data: Data
    let name: String
    let fileName: String
    let mimeType: String
}

class APIUploadInputBase: APIInputBase {
    let data: [APIUploadData]
    
    init(data: [APIUploadData],
         urlString: String,
         parameters: [String: Any]?,
         requestType: HTTPMethod,
         requireAccessToken: Bool) {
        
        self.data = data
        
        super.init(
            urlString: urlString,
            parameters: parameters,
            requestType: requestType,
            requireAccessToken: requireAccessToken
        )
    }
}


