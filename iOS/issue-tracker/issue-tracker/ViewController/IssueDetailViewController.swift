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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommentTextField()
        configureCommentTableView()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)

        commentTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        commentTextField.rightView = commentPostButton
        commentTextField.rightViewMode = .always
        commentPostButton.addTarget(self, action: #selector(postComment), for: .touchUpInside)
        
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
        
    }
    
    @objc func keyboardWillShow(_ sender: NSNotification) {
        self.view.frame.origin.y = -300
    }
    
    @objc func keyboardWillHide(_ sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @IBAction func pressedSeeMoreButton(_ sender: UIButton) {
        guard let popUpViewController = self.storyboard?.instantiateViewController(identifier: IssueDetailPopUpViewController.identifier) as? IssueDetailPopUpViewController else {
            return
        }
        
        popUpViewController.modalPresentationStyle = .overCurrentContext
        self.present(popUpViewController, animated: false, completion: nil)
    }
    
}

extension IssueDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
}
