import Foundation
import Combine

class IssueDetailUseCase {
    
    private let endPoint: EndPoint
    private let networkManager: NetworkManager
    private var subscriptions: Set<AnyCancellable>
    
    init() {
        self.endPoint = EndPoint(scheme: Scheme.http.rawValue, host: Host.base.rawValue, path: Path.api.rawValue)
        self.networkManager = NetworkManager(requestManager: RequestManager(jwtManager: JWTManager()), session: URLSession.shared)
        self.subscriptions = Set<AnyCancellable>()
    }
    
    func executeFetchingLabelList(issueID: Int, completion: @escaping (Result<IssueDetail, NetworkError>) -> Void) {
        let url = endPoint.makeURL(with: "\(Path.issues.rawValue)/\(issueID)")
        networkManager.sendRequest(with: url, method: .get, type: IssueDetailResponseDTO.self)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { issueDetailResponseDTO in
                completion(.success(issueDetailResponseDTO.toDomain()))
            }.store(in: &subscriptions)
    }
    
    func executeAddingNewComment(issueID: Int, comment: NewCommentDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let path = "\(Path.issues.rawValue)/\(issueID)\(Path.comments.rawValue)"
        let url = endPoint.makeURL(with: path)
        networkManager.sendRequest(with: url, method: .post, type: ResponseBodyDTO.self, body: comment)
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
    
    func executeAddingNewEmoji(commentID: Int, emoji: NewEmojiDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let path = "\(Path.comments.rawValue)/\(commentID)\(Path.emojis.rawValue)"
        let url = endPoint.makeURL(with: path)
        networkManager.sendRequest(with: url, method: .post, type: ResponseBodyDTO.self, body: emoji)
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
        
    func executeEditingComment(commentID: Int, comment: NewCommentDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let path = "\(Path.comments.rawValue)/\(commentID)"
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
    
    func executeDeleteComment(_ commentID: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let path = "\(Path.comments.rawValue)/\(commentID)"
        let url = endPoint.makeURL(with: path)
        networkManager.sendRequest(with: url, method: .delete, type: ResponseBodyDTO.self)
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
}
