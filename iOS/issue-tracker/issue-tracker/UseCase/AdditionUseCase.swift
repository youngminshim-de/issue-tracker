import Foundation
import Combine

class AdditionUseCase {
    
    private let endPoint: EndPoint
    private let networkManager: NetworkManager
    private var subscriptions: Set<AnyCancellable>
    
    init() {
        self.endPoint = EndPoint(scheme: Scheme.http.rawValue, host: Host.base.rawValue, path: Path.api.rawValue)
        self.networkManager = NetworkManager(requestManager: RequestManager(jwtManager: JWTManager()), session: URLSession.shared)
        self.subscriptions = Set<AnyCancellable>()
    }
    
    func executeAddingLabel(_ newLabel: NewLabelDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let url = endPoint.makeURL(with: Path.label.rawValue)
        networkManager.sendRequest(with: url, method: .post, type: ResponseBodyDTO.self, body: newLabel)
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
    
    func executeEditingLabel(_ newLabel: NewLabelDTO, labelID: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let url = endPoint.makeURL(with: "\(Path.label.rawValue)/\(labelID)")
        networkManager.sendRequest(with: url, method: .put, type: ResponseBodyDTO.self, body: newLabel)
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
    
    func executeAddingMilestone(_ newMilestone: NewMilestoneDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let url = endPoint.makeURL(with: Path.milestones.rawValue)
        networkManager.sendRequest(with: url, method: .post, type: ResponseBodyDTO.self, body: newMilestone)
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
    
    func executeEditingMilestone(_ newMilestone: NewMilestoneDTO, milestoneID: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let url = endPoint.makeURL(with: "\(Path.milestones.rawValue)/\(milestoneID)")
        networkManager.sendRequest(with: url, method: .put, type: ResponseBodyDTO.self, body: newMilestone)
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
