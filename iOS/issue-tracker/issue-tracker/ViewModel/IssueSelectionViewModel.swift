import Foundation
import Combine

class IssueSelectionViewModel {
    
    @Published private var issueList: IssueList
    @Published private var resultMessage: String?
    @Published private var isAllSelected: Bool
    @Published private var selectedIssueInfo: String
    @Published private var isCloseable: Bool
    private var selectedIssueIndex: [Int]
    private let defaultIssueListUseCase: DefaultIssueListUseCase
    
    init() {
        self.issueList = IssueList(issues: [])
        self.resultMessage = nil
        self.isAllSelected = false
        self.selectedIssueInfo = ""
        self.isCloseable = false
        self.selectedIssueIndex = []
        self.defaultIssueListUseCase = DefaultIssueListUseCase()
        self.updateSelectedIssueInfo()
    }
    
    func didUpdateIssueList() -> AnyPublisher<IssueList, Never> {
        return $issueList
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateResultMessage() -> AnyPublisher<String?, Never> {
        return $resultMessage
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateSelectedIssueInfo() -> AnyPublisher<String, Never> {
        return $selectedIssueInfo
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateIsAllSelected() -> AnyPublisher<Bool, Never> {
        return $isAllSelected
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateIsCloseable() -> AnyPublisher<Bool, Never> {
        return $isCloseable
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func setIssues(_ issues: IssueList) {
        self.issueList = issues
    }
    
    func issueCount() -> Int {
        return issueList.issues.count
    }
    
    func issue(indexPath: IndexPath) -> Issue {
        return issueList.issues[indexPath.row]
    }
    
    func updateSelectdIssue(indexPath: IndexPath) {
        self.selectedIssueIndex.append(indexPath.row)
        updateSelectedIssueInfo()
        updateIsAllSelected()
        updateIsCloseable()
    }
    
    func deleteSelectedIssue(indexPath: IndexPath) {
        self.selectedIssueIndex.removeAll(where: { $0 == indexPath.row })
        updateSelectedIssueInfo()
        updateIsAllSelected()
        updateIsCloseable()
    }
    
    func selectAll() {
        self.selectedIssueIndex = self.issueList.issues.enumerated().map { $0.offset }
        updateSelectedIssueInfo()
        updateIsAllSelected()
        updateIsCloseable()
    }
    
    func deselectAll() {
        self.selectedIssueIndex = []
        updateSelectedIssueInfo()
        updateIsAllSelected()
        updateIsCloseable()
    }
    
    func closeIssues() {
        let issueIDs = self.selectedIssueIndex.map { self.issueList.issues[$0].id }
        self.defaultIssueListUseCase.executeCloseIssue(issueIDs: issueIDs) { result in
            switch result {
            case .failure(_):
//                self.errorMessage = errorMessage
            break
            case .success(let resultMessage):
                self.resultMessage = resultMessage
            }
        }
    }
    
    private func updateSelectedIssueInfo() {
        if self.selectedIssueIndex.isEmpty {
            self.selectedIssueInfo = "이슈를 선택하세요"
        } else {
            self.selectedIssueInfo = "\(self.selectedIssueIndex.count)개의 이슈가 선택됨"
        }
    }
    
    private func updateIsAllSelected() {
        if self.issueList.issues.count == 0 {
            self.isAllSelected = false
            return
        }
        
        self.isAllSelected = (self.issueList.issues.count == self.selectedIssueIndex.count) ?
            true : false
    }
    
    private func updateIsCloseable() {
        self.isCloseable = !self.selectedIssueIndex.isEmpty
    }
    
}
