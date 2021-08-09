import Foundation
import Combine

class IssueDetailPopUpUseCase {
    
    private let endPoint: EndPoint
    private let networkManager: NetworkManager
    private var subscriptions: Set<AnyCancellable>
    
    init() {
        self.endPoint = EndPoint(scheme: Scheme.http.rawValue, host: Host.base.rawValue, path: Path.api.rawValue + Path.issues.rawValue)
        self.networkManager = NetworkManager(requestManager: RequestManager(jwtManager: JWTManager()), session: URLSession.shared)
        self.subscriptions = Set<AnyCancellable>()
    }
    
    func executeFetchingLabelList(issueID: Int, completion: @escaping (Result<IssueDetail, NetworkError>) -> Void) {
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
    
    func executeEditIssueInfo(issueID: Int, additionalInfo: [AdditionalInfo], infoType: IssueAdditionalInfo, completion: @escaping (Result<IssueEditResult, NetworkError>) -> Void) {
        let url = endPoint.makeURL(with: "/\(issueID)" + makePath(of: infoType))
        let editDTO = makeDTO(additionalInfo: additionalInfo, infoType: infoType)

        networkManager.sendRequest(with: url, method: .patch, type: ResponseBodyDTO.self, body: editDTO)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { response in
                if response.error != nil {
                    completion(.success(.error))
                } else {
                    if response.data != nil {
                        completion(.success(.additionInfoEdited))
                    }
                }
            }.store(in: &subscriptions)
    }
    
    func executeChangingIssueState(issueID: Int, state: String, completion: @escaping (Result<IssueEditResult, NetworkError>) -> Void) {
        let url = endPoint.makeURL(with: "/\(state)")
        let issueDTO = IssueIDsDTO(issueIds: [issueID])
        
        networkManager.sendRequest(with: url, method: .post, type: ResponseBodyDTO.self, body: issueDTO)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { response in
                if response.error != nil {
                    completion(.success(.error))
                } else {
                    if response.data != nil {
                        completion(.success(.stateChanged))
                    }
                }
            }.store(in: &subscriptions)
    }
    
    func executeDeleteIssueState(issueID: Int, completion: @escaping (Result<IssueEditResult, NetworkError>) -> Void) {
        let url = endPoint.makeURL(with: "/\(issueID)")
        
        networkManager.sendRequest(with: url, method: .delete, type: ResponseBodyDTO.self)
            .sink { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { response in
                if response.error != nil {
                    completion(.success(.error))
                } else {
                    if response.data != nil {
                        completion(.success(.delete))
                    }
                }
            }.store(in: &subscriptions)
    }
    
    private func makePath(of infoType: IssueAdditionalInfo) -> String {
        switch infoType {
        case .label:
            return Path.label.rawValue
        case .milestone:
            return Path.milestone.rawValue
        case .assignee:
            return Path.assignees.rawValue
        }
    }
    
    private func makeDTO(additionalInfo: [AdditionalInfo], infoType: IssueAdditionalInfo) -> IssueAdditionEditDTO {
        switch infoType {
        case .label:
            return IssueAdditionEditDTO(labelIds: additionalInfo.map { $0.id }, milestoneId: nil, assigneeIds: nil)
        case .milestone:
            return IssueAdditionEditDTO(labelIds: nil, milestoneId: additionalInfo.first?.id, assigneeIds: nil)
        case .assignee:
            return IssueAdditionEditDTO(labelIds: nil, milestoneId: nil, assigneeIds: additionalInfo.map { $0.id })
        }
    }
    
}
