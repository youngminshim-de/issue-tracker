import Foundation
import Combine

class MilestoneAdditionViewModel {
    
    @Published private var isCorrectDueDate: Bool
    @Published private var isEnableSaveButton: Bool
    @Published private var resultMessage: String?
    private var title: String
    private var description: String?
    private var dueDate: String
    private let additionUseCase: AdditionUseCase
    
    init() {
        self.isCorrectDueDate = true
        self.isEnableSaveButton = false
        self.resultMessage = nil
        self.title = ""
        self.description = nil
        self.dueDate = ""
        self.additionUseCase = AdditionUseCase()
    }
    
    func addNewMildestone() {
        additionUseCase.executeAddingMilestone(makeNewMilestoneDTO()) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let resultMessage):
                self.resultMessage = resultMessage
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
        if self.isCorrectFormat(dueDate) || dueDate == "" {
            self.isCorrectDueDate = true
            self.dueDate = dueDate
        }
        self.isEnableSaveButton = self.isCorrectDueDate && isNotEmptyTitle()
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        return dateFormatter.date(from: dueDate) != nil
    }
    
    func makeNewMilestoneDTO() -> NewMilestoneDTO {
        return NewMilestoneDTO(title: self.title, content: self.description, dueDate: self.dueDate)
    }
    
}
