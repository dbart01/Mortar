import Mortar

public class Request {

    public static func google() -> URLRequest {
        let url = URL(string: "https://www.google.com")!
        return URLRequest(url: url)
    }
    
    public static func shopify() -> URLRequest {
        let url = URL(string: "https://www.google.com")!
        return URLRequest(url: url)
    }
    
    public static func to(url: URL) -> URLRequest {
        var request        = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json",    forHTTPHeaderField: "Accept")
        return request
    }
}
