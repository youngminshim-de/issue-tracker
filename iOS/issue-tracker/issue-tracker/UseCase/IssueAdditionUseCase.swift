import Foundation
import Combine

class IssueAdditionUseCase {
    
    private let endPoint: EndPoint
    private let networkManager: NetworkManager
    private var subscriptions: Set<AnyCancellable>
    
    init() {
        self.endPoint = EndPoint(scheme: Scheme.http.rawValue, host: Host.base.rawValue, path: Path.api.rawValue + Path.issues.rawValue)
        self.networkManager = NetworkManager(requestManager: RequestManager(jwtManager: JWTManager()), session: URLSession.shared)
        self.subscriptions = Set<AnyCancellable>()
    }
    
    func executeAddingIssue(_ newIssue: IssueAdditionDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let url = endPoint.makeURL()
        networkManager.sendRequest(with: url, method: .post, type: ResponseBodyDTO.self, body: newIssue)
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
