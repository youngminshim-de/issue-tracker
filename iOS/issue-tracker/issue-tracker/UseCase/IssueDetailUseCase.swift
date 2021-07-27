import Foundation
import Combine

class IssueDetailUseCase {
    
    private let endPoint: EndPoint
    private let networkManager: NetworkManager
    private var subscriptions: Set<AnyCancellable>
    
    init() {
        self.endPoint = EndPoint(scheme: Scheme.http.rawValue, host: Host.base.rawValue, path: Path.api.rawValue + Path.issues.rawValue)
        self.networkManager = NetworkManager(requestManager: RequestManager(jwtManager: JWTManager()), session: URLSession.shared)
        self.subscriptions = Set<AnyCancellable>()
    }
    
    func executeFetchingLabelList(_ issueID: Int, completion: @escaping (Result<IssueDetail, NetworkError>) -> Void) {
        let url = endPoint.makeURL(with: "/\(issueID)")
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
    
}
