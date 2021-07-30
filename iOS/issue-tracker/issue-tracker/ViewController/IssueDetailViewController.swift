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
    
    let emojiContainerView: UIView = {
        let containerView = UIView()
//        let containerView = UIImageView(image: UIImage(named: "emojiBox")?.withAlpha(0.85))
//        containerView.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        containerView.backgroundColor = .clear
        containerView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        
        let containerBackgroundImageView = UIImageView()
        containerBackgroundImageView.image = UIImage(named: "emojiBox")
        
//        let emojis = ["😊", "😳", "❤️", "☀️", "☁️", "🥇", "🎉", "😭", "👍", "🔥"]
        let emojisArray1 = ["😊", "😳", "❤️", "☀️", "☁️"]
        let emojisArray2 = ["🥇", "🎉", "😭", "👍", "🔥"]
        let emojiHeight: CGFloat = 40
        let padding: CGFloat = 8
        
        let emojiSubviews1: [UIView] = emojisArray1.map({ emoji in
            let label = UILabel()
            label.backgroundColor = .clear
            label.text = emoji
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            return label
        })
        
        let emojiSubviews2: [UIView] = emojisArray2.map({ emoji in
            let label = UILabel()
            label.backgroundColor = .clear
            label.text = emoji
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            return label
        })
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        
        let stackView = UIStackView(arrangedSubviews: emojiSubviews1)
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        let stackView2 = UIStackView(arrangedSubviews: emojiSubviews2)
        stackView2.distribution = .fillEqually
        stackView2.spacing = padding
        stackView2.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView2.isLayoutMarginsRelativeArrangement = true
        
        let containerStackview = UIStackView(arrangedSubviews: [stackView, stackView2])
        containerStackview.axis = .vertical
        containerStackview.distribution = .fillEqually
        containerStackview.spacing = 0
        containerStackview.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        containerStackview.isLayoutMarginsRelativeArrangement = true
        
        let emojiCountInRow = CGFloat(emojisArray1.count)
        let width = emojiCountInRow * emojiHeight + (emojiCountInRow + 1) * padding
        let height = emojiHeight * 2 + 3 * padding
        
        containerView.addSubview(containerBackgroundImageView)
        containerView.addSubview(containerStackview)
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        containerView.layer.cornerRadius = 15
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray6.cgColor
        containerView.layer.shadowColor = UIColor(white: 0.1, alpha: 0.6).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        containerBackgroundImageView.frame = containerView.frame
        containerStackview.frame = containerView.frame

        return containerView
    }()
    
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
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
//        view.addSubview(emojiContainerView)
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        let hitTest = emojiContainerView.hitTest(gesture.location(in: emojiContainerView), with: nil)
        if hitTest == nil {
            print(hitTest)
            emojiContainerView.removeFromSuperview()
        }
        
        if hitTest is UILabel {
            hitTest?.alpha = 0
            print(hitTest as? UILabel)
        }
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
        cell.index = indexPath.row
        cell.delegate = self
        
        return cell
    }
}

extension IssueDetailViewController: CommentTableViewCellDelegate {
    
    func CommentTableViewCellActionDidFinish(index: Int, sender: UIButton) {
        print(index, sender)
        
        // 이미 버튼이 눌린 상태면 지우기
        if self.emojiContainerView.superview != nil {
            self.emojiContainerView.removeFromSuperview()
            return
        }
        
        if let buttonLocation = sender.superview?.convert(sender.frame, to: self.view) {
            let x = (buttonLocation.minX + buttonLocation.size.width) - emojiContainerView.frame.width
            let y = buttonLocation.minY
            view.addSubview(emojiContainerView)
            print(x, y)
            emojiContainerView.alpha = 0
            emojiContainerView.transform = CGAffineTransform(translationX: x, y: y)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
                self.emojiContainerView.alpha = 1
                self.emojiContainerView.transform = CGAffineTransform(translationX: x, y: y + buttonLocation.size.height)
            }
        }
        
    }
    
}

extension IssueDetailViewController: Identifying { }
