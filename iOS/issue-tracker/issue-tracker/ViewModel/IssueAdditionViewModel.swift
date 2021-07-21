import Foundation
import Combine

class IssueAdditionViewModel {

    @Published private var isEnableSaveButton: Bool
    @Published private var resultMessage: String?
    @Published private var labels: [AdditionalInfo]
    @Published private var milestones: [AdditionalInfo]
    @Published private var assignees: [AdditionalInfo]
    private var title: String
    private var comment: String
    private var file: String?
    private let issueAdditionUseCase: IssueAdditionUseCase
    
    init() {
        self.isEnableSaveButton = false
        self.labels = []
        self.milestones = []
        self.assignees = []
        self.resultMessage = nil
        self.title = ""
        self.comment = ""
        self.file = nil
        self.issueAdditionUseCase = IssueAdditionUseCase()
    }
    
    func AddNewIssue() {
        let newIssue = self.makeIssueAddition()
        self.issueAdditionUseCase.executeAddingIssue(newIssue) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let resultMessage):
                self.resultMessage = resultMessage
            }
        }
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
    
    func didUpdateResultMessage() -> AnyPublisher<String?, Never> {
        return $resultMessage
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func makeIssueAddition() -> IssueAdditionDTO {
        return IssueAdditionDTO(title: self.title, comment: self.comment, file: self.file, labelIds: self.labels.map { $0.id }, milestoneId: self.milestones.reduce(0) { $0 + $1.id }, assigneeIds: self.assignees.map { $0.id })
    }
}
