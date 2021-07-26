import Foundation
import Combine

class FilterViewModel {
    
    @Published private var userList: UserList
    @Published private var labelList: LabelList
    @Published private var milestoneList: MilestoneList
    private let filterUseCase: AdditionalInfoUseCase
    
    init() {
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
    
    func user(indexPath: IndexPath) -> String {
        return self.userList.users[indexPath.row].username
    }
    
    func label(indexPath: IndexPath) -> String {
        return self.labelList.labels[indexPath.row].title
    }
    
    func milestone(indexPath: IndexPath) -> String {
        return self.milestoneList.Milestones[indexPath.row].title
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
