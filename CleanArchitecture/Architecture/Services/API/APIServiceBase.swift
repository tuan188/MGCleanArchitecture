import ObjectMapper
import Alamofire
import RxSwift
import RxAlamofire

func == <K, V>(left: [K:V], right: [K:V]) -> Bool {
    return NSDictionary(dictionary: left).isEqual(to: right)
}

typealias JSONDictionary = [String: Any]

class APIBase {
    
    var manager: Alamofire.SessionManager
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func request<T: Mappable>(_ input: APIInputBase) -> Observable<T> {
        return request(input)
            .map { json -> T in
                if let t = T(JSON: json) {
                    return t
                }
                throw APIInvalidResponseError()
            }
    }
    
    fileprivate func request(_ input: APIInputBase) -> Observable<JSONDictionary> {
        let user = input.user
        let password = input.password
        let urlRequest = preprocess(input)
            .do(onNext: { input in
                print(input)
            })
            .flatMapLatest { [unowned self] input -> Observable<DataRequest> in
                if let uploadInput = input as? APIUploadInputBase {
                    return self.manager.rx
                        .upload(to: uploadInput.urlString,
                                method: uploadInput.requestType,
                                headers: uploadInput.headers) { (multipartFormData) in
                                    input.parameters?.forEach { key, value in
                                        if let data = String(describing: value).data(using:.utf8) {
                                            multipartFormData.append(data, withName: key)
                                        }
                                    }
                                    uploadInput.data.forEach({
                                        multipartFormData.append(
                                            $0.data,
                                            withName: $0.name,
                                            fileName: $0.fileName,
                                            mimeType: $0.mimeType)
                                    })
                        }
                        .map { $0 as DataRequest }
                } else {
                    return self.manager.rx
                        .request(input.requestType,
                                 input.urlString,
                                 parameters: input.parameters,
                                 encoding: input.encoding,
                                 headers: input.headers)
                }
            }
            .do(onNext: { (_) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
            })
            .flatMapLatest { dataRequest -> Observable<(HTTPURLResponse, Data)> in
                if let user = user, let password = password {
                    return dataRequest
                        .authenticate(user: user, password: password)
                        .rx.responseData()
                }
                return dataRequest.rx.responseData()
            }
            .do(onNext: { (_) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }, onError: { (_) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            })
            .map { (dataResponse) -> JSONDictionary in
                return try self.process(dataResponse)
            }
            .catchError { [unowned self] error -> Observable<JSONDictionary> in
                return try self.handleRequestError(error)
            }
            .do(onNext: { (json) in
                if input.useCache {
                    DispatchQueue.global().async {
                        try? CacheManager.sharedInstance.write(urlString: input.urlEncodingString, data: json)
                    }
                }
            })
        
        let cacheRequest = Observable.just(input)
            .filter { $0.useCache }
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            .map {
                try CacheManager.sharedInstance.read(urlString: $0.urlEncodingString)
            }
            .catchError({ (error) -> Observable<JSONDictionary> in
                print(error)
                return Observable.empty()
            })
        
        return input.useCache
            ? Observable.concat(cacheRequest, urlRequest).distinctUntilChanged (==)
            : urlRequest
    }
    
    func preprocess(_ input: APIInputBase) -> Observable<APIInputBase> {
        return Observable.just(input)
    }
    
    func process(_ response: (HTTPURLResponse, Data)) throws -> JSONDictionary {
        let (response, data) = response
        let json: JSONDictionary? = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSONDictionary
        let error: Error
        let statusCode = response.statusCode
        switch statusCode {
        case 200..<300:
            print("👍 [\(statusCode)] " + (response.url?.absoluteString ?? ""))
            return json ?? JSONDictionary()
        default:
            error = handleResponseError(response: response, data: data, json: json)
            print("❌ [\(statusCode)] " + (response.url?.absoluteString ?? ""))
            if let json = json {
                print(json)
            } else {
                print(data)
            }
        }
        throw error
    }
    
    func handleRequestError(_ error: Error) throws -> Observable<JSONDictionary> {
        throw error
    }
    
    func handleResponseError(response: HTTPURLResponse, data: Data, json: JSONDictionary?) -> Error {
        return APIUnknownError(statusCode: response.statusCode)
    }

}
