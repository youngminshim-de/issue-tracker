import Foundation
import Combine

class CommentModificationViewModel {
    
    @Published private var resultMessage: String?
    private var commentID: Int
    private var content: String
    private var file: String?
    private let issueDetailUseCase: IssueDetailUseCase
    
    init() {
        self.resultMessage = nil
        self.commentID = 0
        self.content = ""
        self.file = nil
        self.issueDetailUseCase = IssueDetailUseCase()
    }
    
    func editingComment(_ comment: NewCommentDTO) {
        issueDetailUseCase.executeEditingComment(commentID: self.commentID, comment: comment) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
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
    
    func setCommentID(_ commentID: Int) {
        self.commentID = commentID
    }
    
    func setContent(_ content: String) {
        self.content = content
    }
    
    func setFile(_ file: String) {
        self.file = file
    }
    
    func NewCommentDTO() -> NewCommentDTO {
        return .init(content: self.content, file: self.file)
    }
}
