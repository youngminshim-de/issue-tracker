import Foundation
import Combine

class IssueDetailPopUpViewModel {
    
    @Published private var issueDetail: IssueDetail?
    @Published private var resultMessage: String?
    private let issueDetailPopUpUseCase: IssueDetailPopUpUseCase
    
    init() {
        self.issueDetail = nil
        self.resultMessage = nil
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
    
    func didUpdateIssueDetail() -> AnyPublisher<IssueDetail?, Never> {
        return $issueDetail
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateResultMessage() -> AnyPublisher<String?, Never> {
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
