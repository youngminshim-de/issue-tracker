import Foundation
import Combine

class CommentModificationViewModel {
    
    @Published private var resultMessage: String?
    private var commentID: Int
    private var content: String
    @Published private var file: String?
    private let commentModificationUseCase: CommentModificationUseCase
    
    init() {
        self.resultMessage = nil
        self.commentID = 0
        self.content = ""
        self.file = nil
        self.commentModificationUseCase = CommentModificationUseCase()
    }
    
    func editingComment(_ comment: NewCommentDTO) {
        commentModificationUseCase.executeEditingComment(commentID: self.commentID, comment: comment) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let resultMessage):
                self.resultMessage = resultMessage
            }
        }
    }
    
    func uploadImage(imageData: String?) {
        self.commentModificationUseCase.executeUploadImage(imageData: imageData) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let imageLink):
                self.file = imageLink
            }
        }
    }
    
    func didUpdateResultMessage() -> AnyPublisher<String?, Never> {
        return $resultMessage
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func didUpdateFile() -> AnyPublisher<String?, Never> {
        return $file
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func setExistingComment(_ comment: Comment) {
        self.commentID = comment.commentID
        self.content = comment.content
        self.file = comment.file
    }
    
    func setContent(_ content: String) {
        self.content = content
    }
    
    func deleteFile() {
        self.file = nil
    }
    
    func comment() -> String {
        return self.content
    }
    
    func NewCommentDTO() -> NewCommentDTO {
        return .init(content: self.content, file: self.file)
    }
}
