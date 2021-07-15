import Foundation
import Combine

class AdditionalInfoViewModel {
    
    enum IssueAdditionalInfo: String {
        case label = "레이블"
        case milestone = "마일스톤"
        case assignee = "담당자"
    }
    
    @Published private var additionalInfo: [AdditionalInfo]
    private let additionalInfoUseCase: AdditionalInfoUseCase
    private var infoType: IssueAdditionalInfo
    
    init() {
        self.additionalInfo = []
        self.additionalInfoUseCase = AdditionalInfoUseCase()
        self.infoType = .label
    }
    
    func setInfoType(of info: IssueAdditionalInfo) {
        self.infoType = info
    }
    
    func fetchAdditionalInfo() {
        switch self.infoType {
        case .label:
            self.fetchLabelList()
        case .milestone:
            self.fetchMilestoneList()
        case .assignee:
            break
        }
    }
    
    private func fetchLabelList() {
        additionalInfoUseCase.executeFetchingLabelList { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let labelList):
                for label in labelList.labels {
                    self.additionalInfo.append(AdditionalInfo.init(id: label.id, title: label.title))
                }
            }
        }
    }
    
    private func fetchMilestoneList() {
        additionalInfoUseCase.executeFetchingMilestoneList { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let milestoneList):
                for milestone in milestoneList.Milestones {
                    self.additionalInfo.append(AdditionalInfo.init(id: milestone.id, title: milestone.title))
                }
            }
        }
    }
    
    func didUpdateAdditionalInfo() -> AnyPublisher<[AdditionalInfo], Never> {
        return $additionalInfo
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func additionalInfoType() -> IssueAdditionalInfo {
        return self.infoType
    }
    
    func additionalInfoCount() -> Int {
        return self.additionalInfo.count
    }
    
    func additionalInfo(indexPath: IndexPath) -> AdditionalInfo {
        return self.additionalInfo[indexPath.row]
    }
    
}
