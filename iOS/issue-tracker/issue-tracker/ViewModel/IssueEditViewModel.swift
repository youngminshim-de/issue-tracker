import Foundation
import Combine

class IssueEditViewModel {
    
    @Published var isSaveButtonEnable: Bool
    @Published private var resultMessage: String?
    private var issueID: Int?
    private var issueTitle: String?
    private let issueEditUseCase: IssueEditUseCase
    
    init() {
        self.isSaveButtonEnable = false
        self.resultMessage = nil
        self.issueID = nil
        self.issueTitle = nil
        self.issueEditUseCase = IssueEditUseCase()
    }
    
    func addNewIssueTitle() {
        guard let issueID = issueID else { return }
        self.issueEditUseCase.executeEditIssueTitle(issueID: issueID, editedTitle: issueTitle) { result in
            switch result {
            case .failure(_):
                break
            case .success(let resultMessage):
                self.resultMessage = resultMessage
            }
        }
    }
    
    func didUpdateResultMessage() -> AnyPublisher<String?, Never> {
        return $resultMessage
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }    
    
    func didUpdateSaveButtonEnable() -> AnyPublisher<Bool, Never> {
        return $isSaveButtonEnable
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func configureIssueTitle(_ text: String?) {
        self.issueTitle = text
        self.isSaveButtonEnable = text != nil && text != "" 
    }
    
    func configureIssueID(_ id: Int?) {
        self.issueID = id
    }
    
    func title() -> String? {
        return self.issueTitle
    }
    
}
