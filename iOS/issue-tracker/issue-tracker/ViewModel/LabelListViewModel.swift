import Foundation
import Combine

class LabelListViewModel {
    
    @Published private var labelList: LabelList
    @Published private var resultMessage: String?
    private let labelListUseCase: LabelListUseCase
    
    init() {
        self.labelList = LabelList(labels: [])
        self.labelListUseCase = LabelListUseCase()
        self.resultMessage = nil
    }
    
    func fetchLabelList() {
        labelListUseCase.executeFetchingLabelList { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let labelList):
                self.labelList = labelList
            }
        }
    }
    
    func didUpdateLabelList() -> AnyPublisher<LabelList, Never> {
        return $labelList
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateResultMessage() -> AnyPublisher<String?, Never> {
        return $resultMessage
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func detailLabelCount() -> Int {
        return labelList.labels.count
    }

    func detailLabel(indexPath: IndexPath) -> DetailLabel {
        return labelList.labels[indexPath.row]
    }
    
    func delete(indexPath: IndexPath) {
        let labelID = labelList.labels[indexPath.row].id
        labelListUseCase.executeDeleteLabel(labelID: labelID) { result in
            switch result {
            case .failure(let errorMessage):
                break
//                self.errorMessage = errorMessage
            case .success(let resultMessage):
                self.resultMessage = resultMessage
            }
        }
    }
    
}
