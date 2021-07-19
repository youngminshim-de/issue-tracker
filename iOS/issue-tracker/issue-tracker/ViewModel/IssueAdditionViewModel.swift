import Foundation
import Combine

class IssueAdditionViewModel {
    
    @Published private var labels: [AdditionalInfo]
    @Published private var milestones: [AdditionalInfo]
    @Published private var assignees: [AdditionalInfo]
    
    init() {
        self.labels = []
        self.milestones = []
        self.assignees = []
    }
    
    func setAdditionalInfo(_ additionalInfo: [AdditionalInfo], infoType: AdditionalInfoViewModel.IssueAdditionalInfo) {
        switch infoType {
        case .label:
            self.labels = additionalInfo
        case .milestone:
            self.milestones = additionalInfo
        case .assignee:
            self.assignees = additionalInfo
        }
    }
    
    func didUpdateLabels() -> AnyPublisher<[AdditionalInfo], Never> {
        return $labels
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateMilestones() -> AnyPublisher<[AdditionalInfo], Never> {
        return $milestones
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateAssignees() -> AnyPublisher<[AdditionalInfo], Never> {
        return $assignees
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
