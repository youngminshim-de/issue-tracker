import Foundation
import Combine

class MilestoneListUseCase {
    
    private let endPoint: EndPoint
    private let networkManager: NetworkManager
    private var subscriptions: Set<AnyCancellable>

    init() {
        self.endPoint = EndPoint(scheme: Scheme.http.rawValue, host: Host.base.rawValue, path: Path.api.rawValue + Path.milestones.rawValue)
        self.networkManager = NetworkManager(requestManager: RequestManager(jwtManager: JWTManager()), session: URLSession.shared)
        self.subscriptions = Set<AnyCancellable>()
    }
    
    func executeFetchingMilestoneList(completion: @escaping (Result<MilestoneList, NetworkError>) -> Void) {
        let url = endPoint.makeURL()
        networkManager.sendRequest(with: url, method: .get, type: MilestoneListResponseDTO.self)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { milestoneListResponseDTO in
                completion(.success(milestoneListResponseDTO.toDomain()))
            }.store(in: &subscriptions)
    }
    
    func executeDeleteMilestone(milestoneID: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let path = "/\(milestoneID)"
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
