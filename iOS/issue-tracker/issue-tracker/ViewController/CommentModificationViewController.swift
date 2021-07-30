import UIKit
import Combine

protocol CommentModificationViewControllerDelegate: AnyObject {
    func CommentModificationViewControllerDidFinish()
}

class CommentModificationViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentViewCenterYConstraint: NSLayoutConstraint!
    
    private let commentModificationViewModel = CommentModificationViewModel()
    private var subscriptions = Set<AnyCancellable>()
    weak var delegate: CommentModificationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        bind()
    }
    
    private func bind() {
        commentModificationViewModel.didUpdateResultMessage()
            .sink { [weak self] resultMessage in
                if resultMessage != nil {
                    self?.delegate?.CommentModificationViewControllerDidFinish()
                    self?.dismiss(animated: false, completion: nil)
                }
            }.store(in: &subscriptions)
    }
    
    func setCommentID(_ commentID: Int) {
        self.commentModificationViewModel.setCommentID(commentID)
    }
    @IBAction func textFiledAction(_ sender: UITextField) {
        guard let content = sender.text else {
            return
        }
        self.commentModificationViewModel.setContent(content)
    }
    
    @IBAction func pressedCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedSaveButton(_ sender: UIButton) {
        self.commentModificationViewModel.editingComment(self.commentModificationViewModel.NewCommentDTO())
        
    }
    
    @IBAction func pressedUpload(_ sender: UIButton) {
        print("hello")
    }
    
}

extension CommentModificationViewController: Identifying { }
