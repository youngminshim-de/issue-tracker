import Foundation
import Combine

class IssueDetailViewModel {
    
    @Published private var issueDetail: IssueDetail?
    private let issueDetailUseCase: IssueDetailUseCase
    
    init() {
        self.issueDetail = nil
        self.issueDetailUseCase = IssueDetailUseCase()
    }
    
    func fetchIssueDetail(_ issueID: Int) {
        self.issueDetailUseCase.executeFetchingLabelList(issueID) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let issueDetail):
                self.issueDetail = issueDetail
            }
        }
    }
    
    func didUpdateIssueDetail() -> AnyPublisher<IssueDetail?, Never> {
        return $issueDetail
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
