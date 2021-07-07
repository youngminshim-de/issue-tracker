import Foundation
import Combine

class MilestoneAdditionViewModel {
    
    @Published private var isCorrectDueDate: Bool
    @Published private var isEnableSaveButton: Bool
    @Published private var dueDate: String
    @Published private var resultMessage: String?
    private var title: String
    private var description: String?
    private let additionUseCase: AdditionUseCase
    
    init() {
        self.isCorrectDueDate = true
        self.isEnableSaveButton = false
        self.dueDate = ""
        self.resultMessage = nil
        self.title = ""
        self.description = nil
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
    
    func didUpdateDueDate() -> AnyPublisher<String, Never> {
        return $dueDate
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func isNotEmptyTitle() -> Bool {
        return self.title.isEmpty == false
    }
    
    func makeNewMilestoneDTO() -> NewMilestoneDTO {
        return NewMilestoneDTO(title: self.title, content: self.description, dueDate: self.dueDate)
    }
}
