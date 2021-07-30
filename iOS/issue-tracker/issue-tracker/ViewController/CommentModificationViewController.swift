import UIKit
import Combine

protocol CommentModificationViewControllerDelegate: AnyObject {
    func CommentModificationViewControllerDidFinish()
}

class CommentModificationViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentViewCenterYConstraint: NSLayoutConstraint!
    
    private let commentViewDefaultHeight: CGFloat = 520
    
    private let commentModificationViewModel = CommentModificationViewModel()
    private var subscriptions = Set<AnyCancellable>()
    weak var delegate: CommentModificationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentViewController()
    }
    
    func animatePresentViewController() {
        self.dimmedView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.commentViewCenterYConstraint.constant = 0
            self.dimmedView.alpha = 0.6
            self.view.layoutIfNeeded()
        }
    }
    
    func animateDismissViewController() {
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
            self.commentViewCenterYConstraint.constant = self.commentViewDefaultHeight
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func bind() {
        commentModificationViewModel.didUpdateResultMessage()
            .sink { [weak self] resultMessage in
                if resultMessage != nil {
                    self?.delegate?.CommentModificationViewControllerDidFinish()
                    self?.animateDismissViewController()
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
        self.animateDismissViewController()
    }
    
    @IBAction func pressedSaveButton(_ sender: UIButton) {
        self.commentModificationViewModel.editingComment(self.commentModificationViewModel.NewCommentDTO())
        
    }
    
    @IBAction func pressedUpload(_ sender: UIButton) {
        print("hello")
    }
    
}

extension CommentModificationViewController: Identifying { }
