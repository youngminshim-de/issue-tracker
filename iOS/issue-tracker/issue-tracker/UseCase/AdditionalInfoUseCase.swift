import Foundation
import Combine

class AdditionalInfoUseCase {
    
    private let endPoint: EndPoint
    private let networkManager: NetworkManager
    private var subscriptions: Set<AnyCancellable>
    
    init() {
        self.endPoint = EndPoint(scheme: Scheme.http.rawValue, host: Host.base.rawValue, path: Path.api.rawValue)
        self.networkManager = NetworkManager(requestManager: RequestManager(jwtManager: JWTManager()), session: URLSession.shared)
        self.subscriptions = Set<AnyCancellable>()
    }
    
    func executeFetchingLabelList(completion: @escaping (Result<LabelList, NetworkError>) -> Void) {
        let url = endPoint.makeURL(with: Path.label.rawValue)
        networkManager.sendRequest(with: url, method: .get, type: LabelListResponseDTO.self)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { labelListResponseDTO in
                completion(.success(labelListResponseDTO.toDomain()))
            }.store(in: &subscriptions)
    }
    
    func executeFetchingMilestoneList(completion: @escaping (Result<MilestoneList, NetworkError>) -> Void) {
        let url = endPoint.makeURL(with: Path.milestones.rawValue)
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
    
    func executeFetchingUserList(completion: @escaping (Result<UserList, NetworkError>) -> Void) {
        let url = endPoint.makeURL(with: Path.users.rawValue)
        networkManager.sendRequest(with: url, method: .get, type: UserListResponseDTO.self)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { userListResponseDTO in
                completion(.success(userListResponseDTO.toDomain()))
            }.store(in: &subscriptions)
    }
    
}
