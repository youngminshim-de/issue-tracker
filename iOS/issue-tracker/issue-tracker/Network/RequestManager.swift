import Foundation

class RequestManager {
    
    private let jwtManager: JWTManageable

    init(jwtManager: JWTManageable) {
        self.jwtManager = jwtManager
    }
    
    private func makeAuthorizationRequest(url: URL) -> URLRequest {
        guard let jwt = jwtManager.get() else {
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        }
        
        var request = URLRequest(url: url)
        let requestValue = "Bearer " + jwt
        let headerField = "Authorization"
        
        request.setValue(requestValue, forHTTPHeaderField: headerField)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func makeRequest(url: URL, method: HttpMethod, body: Data? = nil) -> URLRequest {
        var urlRequest = self.makeAuthorizationRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        return urlRequest
    }
    
    func makeMultipartRequest(imageData: String?) -> URLRequest {
        let endPointToImgur = "https://api.imgur.com/3/image"
        let clientID = "82ac84dde2ec92f"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: endPointToImgur)!)
        request.addValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"

        var body = ""
        body += "--\(boundary)\r\n"
        body += "Content-Disposition:form-data; name=\"image\""
        body += "\r\n\r\n\(imageData ?? "")\r\n"
        body += "--\(boundary)--\r\n"
        
        let postData = body.data(using: .utf8)
        request.httpBody = postData
        
        return request
    }
    
}

enum HttpMethod: String {
    
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
    case patch = "PATCH"
    
}
