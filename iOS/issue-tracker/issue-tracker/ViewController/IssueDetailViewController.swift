import UIKit
import Combine

class IssueDetailViewController: UIViewController, UITextFieldDelegate, CommentModificationViewControllerDelegate {

    @IBOutlet weak var issueTitle: UILabel!
    @IBOutlet weak var issueNumber: UILabel!
    @IBOutlet weak var issueStateView: IssueStateView!
    @IBOutlet weak var writeTime: UILabel!
    @IBOutlet weak var writer: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    private let issueDetailViewModel = IssueDetailViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private var cachedImage = [UIImage?]()
    
    let emojiContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        
        let containerBackgroundImageView = UIImageView()
        containerBackgroundImageView.image = UIImage(named: "emojiBox")
        
        let emojiArray = ["😊", "😳", "❤️", "☀️", "☁️", "🥇", "🎉", "😭", "👍", "🔥"]
        let emojiUpperArray = emojiArray[0 ..< emojiArray.count / 2]
        let emojiLowerArray = emojiArray[emojiArray.count / 2 ..< emojiArray.count]
        let emojiHeight: CGFloat = 40
        let padding: CGFloat = 8
        
        let emojiUpperSubviews: [UIView] = emojiUpperArray.map({ emoji in
            let label = UILabel()
            label.backgroundColor = .clear
            label.text = emoji
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            return label
        })
        
        let emojiLowerSubviews: [UIView] = emojiLowerArray.map({ emoji in
            let label = UILabel()
            label.backgroundColor = .clear
            label.text = emoji
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            return label
        })
        
        let upperStackView = UIStackView(arrangedSubviews: emojiUpperSubviews)
        upperStackView.distribution = .fillEqually
        upperStackView.spacing = padding
        upperStackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        upperStackView.isLayoutMarginsRelativeArrangement = true
        
        let lowerStackView = UIStackView(arrangedSubviews: emojiLowerSubviews)
        lowerStackView.distribution = .fillEqually
        lowerStackView.spacing = padding
        lowerStackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        lowerStackView.isLayoutMarginsRelativeArrangement = true
        
        let arrangedStackViews = [upperStackView, lowerStackView]
        
        let containerStackview = UIStackView(arrangedSubviews: arrangedStackViews)
        containerStackview.axis = .vertical
        containerStackview.distribution = .fillEqually
        containerStackview.spacing = 0
        containerStackview.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        containerStackview.isLayoutMarginsRelativeArrangement = true
        
        let emojiCountInRow = CGFloat(emojiArray.count / 2)
        let stackViewLayerCount: CGFloat = CGFloat(arrangedStackViews.count + 1)
        let width = emojiCountInRow * emojiHeight + (emojiCountInRow + 1) * padding
        let height = emojiHeight * 2 + stackViewLayerCount * padding
        
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
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer) {
        let hitTest = emojiContainerView.hitTest(gesture.location(in: emojiContainerView), with: nil)
        
        if hitTest == nil {
            emojiContainerView.removeFromSuperview()
        }
        
        if let hitEmoji = hitTest as? UILabel {
            animateHitEmoji(hitEmoji)
        }
    }
    
    private func animateHitEmoji(_ emoji: UILabel) {
        guard let emojiText = emoji.text else { return }
        
        let firstAnimationDuration: TimeInterval = 0.2
        let secondAnimationDuration: TimeInterval = 0.6
        let x = emojiContainerView.frame.minX
        let y = emojiContainerView.frame.minY
        let dismissDistance: CGFloat = 30
        
        UIView.animate(withDuration: firstAnimationDuration, delay: 0, options: .curveEaseOut) {
            emoji.transform = CGAffineTransform(translationX: 0, y: -10)
        }
        
        UIView.animate(withDuration: secondAnimationDuration, delay: firstAnimationDuration, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.4, options: .curveEaseInOut) {
            emoji.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }
        
        UIView.animate(withDuration: 0.3, delay: firstAnimationDuration + secondAnimationDuration) {
            self.emojiContainerView.transform = CGAffineTransform(translationX: x, y: y + dismissDistance)
            self.emojiContainerView.alpha = 0
        } completion: { _ in
            self.issueDetailViewModel.addNewEmoji(emojiText)
            self.emojiContainerView.removeFromSuperview()
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
                self?.issueStateView.configure(text: issueDetail.isOpen ? "열림" : "닫힘", isOpen: issueDetail.isOpen)
                self?.writer.text = ", \(issueDetail.writer.username)님이 작성했습니다."
                self?.writeTime.text = self?.issueDetailViewModel.relativeCreatedTime(issueDetail.createdTime)
                self?.loadImage()
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
    
    func loadImage() {
        self.cachedImage = [UIImage?](repeating: nil, count: issueDetailViewModel.commentCount())

        for index in 0..<cachedImage.count {
            let indexPath = IndexPath(row: index, section: 0)
            let urlString = issueDetailViewModel.file(indexPath: indexPath)
            guard let imageUrlString = urlString, let imageURL = URL(string: imageUrlString) else { continue }
            
            DispatchQueue.global().async {
                let imageData = try? Data(contentsOf: imageURL)
                guard let data = imageData, let image = UIImage(data: data) else { return }
                self.cachedImage[indexPath.row] = image
                
                DispatchQueue.main.async {
                    self.commentTableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
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
        
        let estimatedRowHeight: CGFloat = 350
        commentTableView.estimatedRowHeight = estimatedRowHeight
    }
    
    private func configureTableViewFooterView() {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        commentTableView.tableFooterView = footerView
    }
    
    private func showCommentModificationViewController(comment: Comment) {
        guard let commentModificationViewController = self.storyboard?.instantiateViewController(identifier: CommentModificationViewController.identifier) as? CommentModificationViewController else {
            return
        }
        
        commentModificationViewController.delegate = self
        commentModificationViewController.setComment(comment)
        commentModificationViewController.modalPresentationStyle = .overCurrentContext
        self.present(commentModificationViewController, animated: false, completion: nil)
    }
    
    func CommentModificationViewControllerDidFinish() {
        self.issueDetailViewModel.fetchIssueDetail()
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
        popUpViewController.delegate = self
        popUpViewController.setIssueDetail(issueDetailViewModel.issueInfo())
        self.present(popUpViewController, animated: false, completion: nil)
    }
    
    @objc func pressedOption(_ sender: UIButton) {
        let touchPoint = sender.convert(CGPoint.zero, to: self.commentTableView)
        guard let clickedButtonIndexPath = self.commentTableView.indexPathForRow(at: touchPoint),
              let clickedCommentInfo = self.issueDetailViewModel.commentInfo(indexPath: clickedButtonIndexPath) else {
            return
        }
        
        self.issueDetailViewModel.setCommentID(indexPath: clickedButtonIndexPath)
        let commentID = clickedCommentInfo.commentID
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "수정", style: .default) { _ in
            self.showCommentModificationViewController(comment: clickedCommentInfo)
        })
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.issueDetailViewModel.delete(commentID: commentID)
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showEmojiCollection(_ sender: UIButton) {
        if self.emojiContainerView.superview != nil {
            self.emojiContainerView.removeFromSuperview()
            return
        }
        
        let touchPoint = sender.convert(CGPoint.zero, to: self.commentTableView)
        
        if let buttonFrame = sender.superview?.convert(sender.frame, to: self.view), let clickedButtonIndexPath = self.commentTableView.indexPathForRow(at: touchPoint) {
            self.issueDetailViewModel.setCommentID(indexPath: clickedButtonIndexPath)
            animatePresentingEmojiContainer(buttonFrame: buttonFrame)
        }
    }
    
    private func animatePresentingEmojiContainer(buttonFrame: CGRect) {
        let x = (buttonFrame.minX + buttonFrame.size.width) - emojiContainerView.frame.width
        let y = buttonFrame.minY
        view.addSubview(emojiContainerView)

        emojiContainerView.alpha = 0
        emojiContainerView.transform = CGAffineTransform(translationX: x, y: y)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.emojiContainerView.alpha = 1
            self.emojiContainerView.transform = CGAffineTransform(translationX: x, y: y + buttonFrame.size.height)
        }
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
    
}

extension IssueDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueDetailViewModel.commentCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        
        if !cachedImage.isEmpty {
            if cachedImage[indexPath.row] == nil {
                cell.setHeightZero()
            } else {
                cell.setDefaultHeight()
                cell.fileImage.image = cachedImage[indexPath.row]
            }
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
            cell.commentOption.addTarget(self, action: #selector(showEmojiCollection(_:)), for: .touchUpInside)
        }
        
        cell.userName.text = self.issueDetailViewModel.commentUsername(indexPath: indexPath)
        cell.writeTime.text = self.issueDetailViewModel.commentWriteTime(indexPath: indexPath)
        cell.comment.text = self.issueDetailViewModel.comment(indexPath: indexPath)
        cell.emojis = self.issueDetailViewModel.emojis(indexPath: indexPath)
        return cell
    }
}

extension IssueDetailViewController: IssueDetailPopUpViewControllerDelegate {
    
    func IssueDetailPopUpViewControllerDidFinishEditing() {
        self.issueDetailViewModel.fetchIssueDetail()
    }
    
    func IssueDetailPopUpViewControllerDidFinishDeleting() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension IssueDetailViewController: Identifying { }
