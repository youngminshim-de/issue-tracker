import Foundation
import Combine

class MilestoneAdditionViewModel {
    
    @Published private var isCorrectDueDate: Bool
    @Published private var isEnableSaveButton: Bool
    @Published private var resultMessage: String?
    private var id: Int?
    private var title: String
    private var description: String?
    private var dueDate: String
    private let additionUseCase: AdditionUseCase
    
    init() {
        self.isCorrectDueDate = true
        self.isEnableSaveButton = false
        self.resultMessage = nil
        self.id = nil
        self.title = ""
        self.description = nil
        self.dueDate = ""
        self.additionUseCase = AdditionUseCase()
    }
    
    func updateMildestone() {
        if let id = self.id {
            additionUseCase.executeEditingMilestone(makeNewMilestoneDTO(), milestoneID: id) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let resultMessage):
                    self.resultMessage = resultMessage
                }
            }
        } else {
            additionUseCase.executeAddingMilestone(makeNewMilestoneDTO()) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let resultMessage):
                    self.resultMessage = resultMessage
                }
            }
        }
    }
    
    func configureTitle(_ title: String) {
        self.title = title
        self.isEnableSaveButton = self.isCorrectDueDate && isNotEmptyTitle()
    }
    
    func configureDescription(_ description: String) {
        self.description = description
    }
    
    func configureDueDate(_ dueDate: String) {
        self.isCorrectDueDate = self.isCorrectFormat(dueDate)
        if self.isCorrectDueDate {
            self.dueDate = dueDate
        }
        self.isEnableSaveButton = self.isCorrectDueDate && isNotEmptyTitle()
    }
    
    //MARK: 편집할 때는 바로 저장 버튼 활성화
    func configureExistingMilestone(_ milestone: DetailMilestone) {
        self.id = milestone.id
        self.title = milestone.title
        self.description = milestone.content
        self.dueDate = milestone.dueDate
        self.isEnableSaveButton = true
    }
    
    func didUpdateResultMessage() -> AnyPublisher<String?, Never> {
        return $resultMessage
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
        
    func didUpdateCorrectDueDate() -> AnyPublisher<Bool, Never> {
        return $isCorrectDueDate
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateSaveButton() -> AnyPublisher<Bool, Never> {
        return $isEnableSaveButton
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func isNotEmptyTitle() -> Bool {
        return self.title.isEmpty == false
    }
    
    private func isCorrectFormat(_ dueDate: String) -> Bool {
        if dueDate == "" {
            return true
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dueDate) != nil
    }
    
    func makeNewMilestoneDTO() -> NewMilestoneDTO {
        return NewMilestoneDTO(title: self.title, content: self.description, dueDate: self.dueDate)
    }
    
}
