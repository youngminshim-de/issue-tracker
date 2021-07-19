import Foundation
import Combine

class IssueAdditionViewModel {
    private var title: String
    private var comment: String
    private var file: String?
    @Published private var isEnableSaveButton: Bool
    @Published private var labels: [AdditionalInfo]
    @Published private var milestones: [AdditionalInfo]
    @Published private var assignees: [AdditionalInfo]
    
    init() {
        self.title = ""
        self.comment = ""
        self.file = nil
        self.isEnableSaveButton = false
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
    
    func configureTitle(_ title: String) {
        self.title = title
        self.isEnableSaveButton = isSaveable()
    }
    
    func configureComment(_ comment: String) {
        self.comment = comment
        self.isEnableSaveButton = isSaveable()
    }
    
    func configureFile(_ file: String?) {
        self.file = file
    }
    
    func isSaveable() -> Bool {
        return self.title != "" && self.comment != ""
    }
    
    func didUpdateSaveButton() -> AnyPublisher<Bool, Never> {
        return $isEnableSaveButton
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
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
    
    func makeIssueAddition() -> IssueAdditionDTO {
        return IssueAdditionDTO(title: self.title, comment: self.comment, file: self.file, labelIds: self.labels.map { $0.id }, milestoneId: self.milestones.reduce(0) { $0 + $1.id }, assigneeIds: self.assignees.map { $0.id })
    }
}
