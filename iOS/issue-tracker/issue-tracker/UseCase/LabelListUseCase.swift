import Foundation
import Combine

class LabelListUseCase {
    
    private let endPoint: EndPoint
    private let networkManager: NetworkManager
    private var subscriptions: Set<AnyCancellable>

    init() {
        self.endPoint = EndPoint(scheme: Scheme.http.rawValue, host: Host.base.rawValue, path: Path.api.rawValue + Path.label.rawValue)
        self.networkManager = NetworkManager(requestManager: RequestManager(jwtManager: JWTManager()), session: URLSession.shared)
        self.subscriptions = Set<AnyCancellable>()
    }
    
    func executeFetchingLabelList(completion: @escaping (Result<LabelList, NetworkError>) -> Void) {
        let url = endPoint.makeURL()
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
    
    func executeDeleteLabel(labelID: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        let path = "/\(labelID)"
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
