import UIKit
import Combine

protocol CommentModificationViewControllerDelegate: AnyObject {
    func CommentModificationViewControllerDidFinish()
}

class CommentModificationViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var fileDeleteButton: UIButton!
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentViewCenterYConstraint: NSLayoutConstraint!
    
    private let commentViewDefaultHeight: CGFloat = 520
    
    private let commentModificationViewModel = CommentModificationViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private let photoPicker = UIImagePickerController()
    private let loadingView = LoadingView()
    weak var delegate: CommentModificationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        self.loadingView.initilize(viewController: self)
        self.photoPicker.delegate = self
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
        
        commentModificationViewModel.didUpdateFile()
            .sink { fileName in
//                if fileName == "" || fileName == nil {
//                    self.fileDeleteButton.isHidden = true
//                } else {
//                    self.fileDeleteButton.isHidden = false
//                }
                self.fileDeleteButton.isHidden = (fileName == "" || fileName == nil)
                self.fileNameLabel.text = fileName
                self.loadingView.stop()
            }.store(in: &subscriptions)
        
        self.commentTextField.text = commentModificationViewModel.comment()
    }
    
    func setComment(_ comment: Comment) {
        self.commentModificationViewModel.setExistingComment(comment)
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
    
    @IBAction func pressedFileUpload(_ sender: UIButton) {
        self.openPhotoLibrary()
    }
    
    @IBAction func pressedFileDelete(_ sender: UIButton) {
        self.commentModificationViewModel.deleteFile()
    }
    
}

extension CommentModificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func openPhotoLibrary() {
        photoPicker.sourceType = .photoLibrary
        present(photoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoPicker.dismiss(animated: true, completion: nil)
            self.loadingView.start()

            let imageData = makeBase64Image(pickedImage)
            self.commentModificationViewModel.uploadImage(imageData: imageData)
        }
    }
    
    private func makeBase64Image(_ image: UIImage) -> String? {
        let imageData = image.jpegData(compressionQuality: 0.5)
        let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
        return base64Image
    }
    
}

extension CommentModificationViewController: Identifying { }
