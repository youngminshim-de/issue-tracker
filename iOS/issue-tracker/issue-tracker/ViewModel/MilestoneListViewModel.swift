import Foundation
import Combine

class MilestoneListViewModel {
    
    @Published private var milestoneList: MilestoneList
    @Published private var resultMessage: String?
    private let milestoneListUseCase: MilestoneListUseCase
    
    init() {
        self.milestoneList = MilestoneList(Milestones: [])
        self.resultMessage = nil
        self.milestoneListUseCase = MilestoneListUseCase()
    }
    
    func fetchMilestoneList() {
        milestoneListUseCase.executeFetchingMilestoneList { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let milestoneList):
                self.milestoneList = milestoneList
            }
        }
    }
    
    func didUpdateMilestoneList() -> AnyPublisher<MilestoneList, Never> {
        return $milestoneList
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateResultMessage() -> AnyPublisher<String?, Never> {
        return $resultMessage
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func detailMilestoneCount() -> Int {
        return milestoneList.Milestones.count
    }

    func detailMilestone(indexPath: IndexPath) -> DetailMilestone {
        return milestoneList.Milestones[indexPath.row]
    }
    
    func delete(indexPath: IndexPath) {
        let milestoneID = milestoneList.Milestones[indexPath.row].id
        milestoneListUseCase.executeDeleteMilestone(milestoneID: milestoneID) { result in
            switch result {
            case .failure(let errorMessage):
                break
//                self.errorMessage = errorMessage
            case .success(let resultMessage):
                self.resultMessage = resultMessage
            }
        }
    }
    
}
