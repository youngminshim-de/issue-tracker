import Foundation
import Combine

class CommentModificationUseCase {
    
    private let endPoint: EndPoint
    private let networkManager: NetworkManager
    private var subscriptions: Set<AnyCancellable>
    
    init() {
        self.endPoint = EndPoint(scheme: Scheme.http.rawValue, host: Host.base.rawValue, path: Path.api.rawValue + Path.comments.rawValue)
        self.networkManager = NetworkManager(requestManager: RequestManager(jwtManager: JWTManager()), session: URLSession.shared)
        self.subscriptions = Set<AnyCancellable>()
    }
        
    func executeEditingComment(commentID: Int, comment: NewCommentDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let path = "/\(commentID)"
        let url = endPoint.makeURL(with: path)
        networkManager.sendRequest(with: url, method: .patch, type: ResponseBodyDTO.self, body: comment)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { response in
                if let error = response.error {
                    completion(.success(error))
                } else {
                    if let data = response.data {
                        completion(.success(data))
                    }
                }
            }.store(in: &subscriptions)
    }
    
    func executeUploadImage(imageData: String?, completion: @escaping (Result<String, NetworkError>) -> Void) {
        networkManager.sendUploadImageToImgur(imageData: imageData)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { response in
                if let error = response.success, !error, let status = response.status {
                    completion(.success("\(status)"))
                } else {
                    if let link = response.data?.link {
                        completion(.success(link))
                    }
                }
            }.store(in: &subscriptions)
    }
    
}
