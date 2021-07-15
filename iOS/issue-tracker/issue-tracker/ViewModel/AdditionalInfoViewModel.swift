import Foundation
import Combine

class AdditionalInfoViewModel {
    
    @Published private var additionalInfo: [AdditionalInfo]
    private let additionalInfoUseCase: AdditionalInfoUseCase
    
    init() {
        self.additionalInfo = []
        self.additionalInfoUseCase = AdditionalInfoUseCase()
    }
    
    func fetchLabelList() {
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
    
    func fetchMilestoneList() {
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
    
    func additionalInfoCount() -> Int {
        return self.additionalInfo.count
    }
    
    func additionalInfo(indexPath: IndexPath) -> AdditionalInfo {
        return self.additionalInfo[indexPath.row]
    }
}
