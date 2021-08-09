import Foundation
import Combine

class IssueEditUseCase {
    
    private let endPoint: EndPoint
    private let networkManager: NetworkManager
    private var subscriptions: Set<AnyCancellable>
    
    init() {
        self.endPoint = EndPoint(scheme: Scheme.http.rawValue, host: Host.base.rawValue, path: Path.api.rawValue + Path.issues.rawValue)
        self.networkManager = NetworkManager(requestManager: RequestManager(jwtManager: JWTManager()), session: URLSession.shared)
        self.subscriptions = Set<AnyCancellable>()
    }
    
    func executeEditIssueTitle(issueID: Int, editedTitle: String?, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let url = endPoint.makeURL(with: "/\(issueID)" + Path.title.rawValue)
        let titleDTO = IssueTitleDTO(title: editedTitle)
        networkManager.sendRequest(with: url, method: .patch, type: ResponseBodyDTO.self, body: titleDTO)
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
