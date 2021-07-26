import Foundation
import Combine

class FilterViewModel {
    
    private var isOpenList: [String]
    private var userStateList: [String]
    @Published private var userList: UserList
    @Published private var labelList: LabelList
    @Published private var milestoneList: MilestoneList
    private let filterUseCase: AdditionalInfoUseCase
    
    init() {
        self.isOpenList = ["열린 이슈", "닫힌 이슈"]
        self.userStateList = ["내가 작성한 이슈", "나에게 할당된 이슈", "내가 댓글을 남긴 이슈"]
        self.userList = UserList(users: [])
        self.labelList = LabelList(labels: [])
        self.milestoneList = MilestoneList(Milestones: [])
        self.filterUseCase = AdditionalInfoUseCase()
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
    
    func isOpen(indexPath: IndexPath) -> String {
        return self.isOpenList[indexPath.row]
    }
    
    func userState(indexPath: IndexPath) -> String {
        return self.userStateList[indexPath.row]
    }
    
    func user(indexPath: IndexPath) -> String {
        return self.userList.users[indexPath.row].username
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
    
}
