import Foundation
import Combine

enum IssueEditResult {
    case none
    case additionInfoEdited
    case stateChanged
    case delete
    case error
}

class IssueDetailPopUpViewModel {
    
    @Published private var issueDetail: IssueDetail?
    @Published private var resultMessage: IssueEditResult
    private let issueDetailPopUpUseCase: IssueDetailPopUpUseCase
    
    init() {
        self.issueDetail = nil
        self.resultMessage = .none
        self.issueDetailPopUpUseCase = IssueDetailPopUpUseCase()
    }
    
    func fetchIssueDetail() {
        guard let id = issueDetail?.issueID else { return }
        self.issueDetailPopUpUseCase.executeFetchingLabelList(issueID: id) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let issueDetail):
                self.issueDetail = issueDetail
            }
        }
    }
    
    func editIssueInfo(additionalInfo: [AdditionalInfo], infoType: IssueAdditionalInfo) {
        guard let id = self.issueDetail?.issueID else { return }
        
        self.issueDetailPopUpUseCase.executeEditIssueInfo(issueID: id, additionalInfo: additionalInfo, infoType: infoType) { result in
            switch result {
            case .failure(_):
                break
            case .success(let resultMessage):
                self.resultMessage = resultMessage
            }
        }
    }
    
    func changeIssueState() {
        guard let id = self.issueDetail?.issueID, let isOpen = self.issueDetail?.isOpen else { return }
        let changedState = isOpen ? "close" : "open"
        
        self.issueDetailPopUpUseCase.executeChangingIssueState(issueID: id, state: changedState) { result in
            switch result {
            case .failure(_):
                break
            case .success(let resultMessage):
                self.resultMessage = resultMessage
            }
        }
    }
    
    func deleteIssue() {
        guard let id = self.issueDetail?.issueID else { return }
        
        self.issueDetailPopUpUseCase.executeDeleteIssueState(issueID: id) { result in
            switch result {
            case .failure(_):
                break
            case .success(let resultMessage):
                self.resultMessage = resultMessage
            }
        }
    }
    
    func didUpdateIssueDetail() -> AnyPublisher<IssueDetail?, Never> {
        return $issueDetail
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateResultMessage() -> AnyPublisher<IssueEditResult, Never> {
        return $resultMessage
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func setIssueDetail(_ issueDetail: IssueDetail?) {
        self.issueDetail = issueDetail
    }
    
    func issueStateLabel() -> String {
        guard let issueDetail = self.issueDetail else { return "" }
        return issueDetail.isOpen ? "이슈 닫기" : "이슈 열기"
    }
    
    func issueID() -> Int? {
        return self.issueDetail?.issueID
    }
    
    func issueTitle() -> String? {
        return self.issueDetail?.title
    }
    
}
