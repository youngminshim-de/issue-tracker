import UIKit
import Combine

class IssueDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var issueTitle: UILabel!
    @IBOutlet weak var issueNumber: UILabel!
    @IBOutlet weak var issueState: UILabel!
    @IBOutlet weak var writeTime: UILabel!
    @IBOutlet weak var writer: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    private let issueDetailViewModel = IssueDetailViewModel()
    private var subscriptions = Set<AnyCancellable>()
//    private var cachedImage = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureCommentTextField()
        configureCommentTableView()
        configureIssueOptionButton()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
        commentTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func bind() {
        issueDetailViewModel.didUpdateIssueDetail()
            .sink { [weak self] issueDetail in
                guard let issueDetail = issueDetail else { return }
                self?.issueTitle.text = issueDetail.title
                self?.issueNumber.text = "#\(issueDetail.issueID)"
                self?.issueState.text = "\(issueDetail.isOpen ? "열림" : "닫힘")"
                self?.writer.text = ",\(issueDetail.writer.username)님이 작성했습니다."
                self?.writeTime.text = self?.issueDetailViewModel.relativeCreatedTime(issueDetail.createdTime)
//                self?.loadImage()
                self?.commentTableView.reloadData()
            }.store(in: &subscriptions)
        
        issueDetailViewModel.didUpdateResultMessage()
            .sink { [weak self] resultMessage in
                if resultMessage != nil {
                    self?.issueDetailViewModel.fetchIssueDetail()
                }
            }.store(in: &subscriptions)
        
        issueDetailViewModel.fetchIssueDetail()
    }
    
//    func loadImage() {
//        self.cachedImage = [UIImage?](repeating: nil, count: issueDetailViewModel.commentCount())
//
//        for index in 0..<cachedImage.count {
//            let indexPath = IndexPath(row: index, section: 0)
//            let urlString = issueDetailViewModel.file(indexPath: indexPath)
//            guard let imageUrlString = urlString, let imageURL = URL(string: imageUrlString) else { continue }
//            DispatchQueue.global().async {
//                let imageData = try? Data(contentsOf: imageURL)
//                guard let data = imageData, let image = UIImage(data: data) else { return }
//                self.cachedImage[indexPath.row] = image
//                DispatchQueue.main.async {
//                    self.commentTableView.beginUpdates()
//                    self.commentTableView.reloadRows(at: [indexPath], with: .fade)
//                    self.commentTableView.endUpdates()
//                }
//            }
//        }
//    }
    
    private func configureIssueOptionButton() {
        let buttonImage = UIImage(systemName: "ellipsis")
        let button = UIButton(type: .system)
        button.setImage(buttonImage, for: .normal)
        button.addTarget(self, action: #selector(pressedIssueOptionButton(_:)), for: .touchUpInside)
        let selectButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = selectButton
    }
    
    func setIssueID(_ issueID: Int) {
        self.issueDetailViewModel.setIssueID(issueID)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func configureCommentTextField() {
        let commentPostButton = UIButton()
        let image = UIImage(systemName: "arrow.up.circle.fill")
        commentPostButton.setImage(image, for: .normal)
        commentPostButton.imageEdgeInsets = .init(top: 0, left: -10, bottom: 0, right: 0)
        commentPostButton.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        commentPostButton.isEnabled = false
        
        commentTextField.rightView = commentPostButton
        commentTextField.rightViewMode = .always
        commentTextField.layer.masksToBounds = true
        commentTextField.layer.cornerRadius = 15
        commentTextField.layer.borderWidth = 1
        commentTextField.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    private func configureCommentTableView() {
        commentTableView.register(CommentTableViewCell.nib, forCellReuseIdentifier: CommentTableViewCell.identifier)
        configureTableViewFooterView()
    }
    
    private func configureTableViewFooterView() {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        commentTableView.tableFooterView = footerView
    }
    
    @objc func postComment() {
        self.issueDetailViewModel.addNewComment()
        self.commentTextField.text = ""
        self.commentTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ sender: NSNotification) {
        self.view.frame.origin.y = -300
    }
    
    @objc func keyboardWillHide(_ sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func pressedIssueOptionButton(_ sender: UIBarButtonItem) {
        guard let popUpViewController = self.storyboard?.instantiateViewController(identifier: IssueDetailPopUpViewController.identifier) as? IssueDetailPopUpViewController else {
            return
        }
        
        popUpViewController.modalPresentationStyle = .overCurrentContext
        self.present(popUpViewController, animated: false, completion: nil)
    }
    
    @IBAction func textFieldAction(_ sender: UITextField) {
        guard let postButton = sender.rightView as? UIButton else { return }
        if sender.text == nil || sender.text == "" {
            postButton.isEnabled = false
        } else {
            postButton.isEnabled = true
            issueDetailViewModel.setNewComment(sender.text!)
        }
    }
    
    private func showCommentModificationViewController(sender: UIButton) {
        guard let commentModificationViewController = self.storyboard?.instantiateViewController(identifier: CommentModificationViewController.identifier) as? CommentModificationViewController else {
            return
        }
        let touchPoint = sender.convert(CGPoint.zero, to: self.commentTableView)
        guard let clickedButtonIndexPath = self.commentTableView.indexPathForRow(at: touchPoint) else { return }
        self.issueDetailViewModel.setCommentID(indexPath: clickedButtonIndexPath)
        commentModificationViewController.modalPresentationStyle = .overCurrentContext
        self.present(commentModificationViewController, animated: false, completion: nil)
    }
    
    @objc func pressedOption(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "수정", style: .default) { _ in
            self.showCommentModificationViewController(sender: sender)
        })
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
            
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showEmojiViewController(_ sender: UIButton) {
        
    }
    
}

extension IssueDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueDetailViewModel.commentCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        
        DispatchQueue.global().async {
            let profileImageUrl = self.issueDetailViewModel.commentProfileImage(indexPath: indexPath)
            guard let imageURL = URL(string: profileImageUrl) else { return }
            let imageData = try? Data(contentsOf: imageURL)
            guard let data = imageData, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                cell.userImageView.image = image
            }
        }
        
        if issueDetailViewModel.writer(indexPath: indexPath) {
            cell.commentOption.addTarget(self, action: #selector(pressedOption(_:)), for: .touchUpInside)
        } else {
            cell.commentOption.setImage(UIImage(systemName: "smiley"), for: .normal)
            cell.commentOption.addTarget(self, action: #selector(showEmojiViewController), for: .touchUpInside)
        }
        
        cell.userName.text = self.issueDetailViewModel.commentUsername(indexPath: indexPath)
        cell.writeTime.text = self.issueDetailViewModel.commentWriteTime(indexPath: indexPath)
        cell.comment.text = self.issueDetailViewModel.comment(indexPath: indexPath)
        
        return cell
    }
}

extension IssueDetailViewController: Identifying { }
