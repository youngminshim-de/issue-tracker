import Foundation
import Combine

class FilterViewModel {
    
    private var isOpenList: [String]
    private var userStateList: [String]
    @Published private var userList: UserList
    @Published private var labelList: LabelList
    @Published private var milestoneList: MilestoneList
    private let filterUseCase: AdditionalInfoUseCase
    private var filterCondition: FilterCondition
    
    init() {
        self.isOpenList = ["열린 이슈", "닫힌 이슈"]
        self.userStateList = ["내가 작성한 이슈", "나에게 할당된 이슈", "내가 댓글을 남긴 이슈"]
        self.userList = UserList(users: [])
        self.labelList = LabelList(labels: [])
        self.milestoneList = MilestoneList(Milestones: [])
        self.filterUseCase = AdditionalInfoUseCase()
        self.filterCondition = FilterCondition()
    }
    
    func fetchAllLists() {
        self.fetchUserList()
        self.fetchLabelList()
        self.fetchMilestoneList()
    }
    
    private func fetchLabelList() {
        filterUseCase.executeFetchingLabelList { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let labelList):
                self.labelList = labelList
            }
        }
    }
    
    private func fetchMilestoneList() {
        filterUseCase.executeFetchingMilestoneList { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let milestoneList):
                self.milestoneList = milestoneList
            }
        }
    }
    
    private func fetchUserList() {
        filterUseCase.executeFetchingUserList { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let userList):
                self.userList = userList
            }
        }
    }
    
    func didUpdateUserList() -> AnyPublisher<UserList, Never> {
        return $userList
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateLabelList() -> AnyPublisher<LabelList, Never> {
        return $labelList
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateMilestoneList() -> AnyPublisher<MilestoneList, Never> {
        return $milestoneList
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func makeFilterCondition() -> FilterCondition {
        return filterCondition
    }
    
    func addFilterCondition(section: IssueListFilterViewController.Section, row: Int) {
        switch section {
        case .isOpen:
            self.filterCondition.isOpen = self.interpretIsOpen(row: row)
        case .userState:
            self.filterCondition.filter = self.interpretUserState(row: row)
        case .writer:
            self.filterCondition.writer = self.userList.users[row].id
        case .label:
            self.filterCondition.label = self.labelList.labels[row].id
        case .mileStone:
            self.filterCondition.milestone = self.milestoneList.Milestones[row].id
        }
    }
    
    func deleteFilterCondition(section: IssueListFilterViewController.Section, row: Int) {
        switch section {
        case .isOpen:
            self.filterCondition.isOpen = nil
        case .userState:
            self.filterCondition.filter = nil
        case .writer:
            self.filterCondition.writer = nil
        case .label:
            self.filterCondition.label = nil
        case .mileStone:
            self.filterCondition.milestone = nil
        }
    }
    
    func isOpen(indexPath: IndexPath) -> String {
        return self.isOpenList[indexPath.row]
    }
    
    func userState(indexPath: IndexPath) -> String {
        return self.userStateList[indexPath.row]
    }
    
    func user(indexPath: IndexPath) -> String {
        return self.userList.users[indexPath.row].userName
    }
    
    func label(indexPath: IndexPath) -> String {
        return self.labelList.labels[indexPath.row].title
    }
    
    func milestone(indexPath: IndexPath) -> String {
        return self.milestoneList.Milestones[indexPath.row].title
    }
    
    func isOpenCount() -> Int {
        return self.isOpenList.count
    }
    
    func userStateCount() -> Int {
        return self.userStateList.count
    }
    
    func userCount() -> Int {
        return self.userList.users.count
    }
    
    func labelCount() -> Int {
        return self.labelList.labels.count
    }
    
    func milestoneCount() -> Int {
        return self.milestoneList.Milestones.count
    }
    
    private func interpretIsOpen(row: Int) -> Bool {
        return row == 0
    }
    
    private func interpretUserState(row: Int) -> String? {
        switch row {
        case 0:
            return "my_issue"
        case 1:
            return "my_comment"
        case 2:
            return "my_assign"
        default:
            return nil
        }
    }

}
