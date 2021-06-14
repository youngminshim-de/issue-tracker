//
//  CommentViewController.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/14.
//

import UIKit

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentTableView: UITableView!
    private var tableHeaderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableHeaderView = setHeaderView()
        setNavigationItem()
        setTextField()
    }
    
    func setNavigationItem() {
        let leftButton = UIButton.setButton(image: "Icon.png", title: " 목록")
        leftButton.addTarget(self, action: #selector(backButtonTouched(_ :)), for: .touchUpInside)
        
        let rightButton = UIButton.setButton(image: "more.png", title: "")
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.commentTableView.tableHeaderView = tableHeaderView
        self.commentTableView.tableHeaderView?.backgroundColor = .white
    }
    
    func setTextField() {
        let sendButton = UIButton()
        sendButton.setImage(UIImage(named: "ButtonSend.png"), for: .normal)
        commentTextField.rightView = sendButton
        commentTextField.rightViewMode = .always
    }
    
    @objc func backButtonTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.commentTableView.bounds.width, height: 115)))
        
        let titleLabel = UILabel()
        let issueNumberLabel = UILabel()
        let statusLabel = PaddingLabel()
        let writerTimeLabel = UILabel()
    
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        issueNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        writerTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(issueNumberLabel)
        headerView.addSubview(statusLabel)
        headerView.addSubview(writerTimeLabel)

        headerView.layer.borderWidth = 1
        headerView.layer.borderColor = UIColor.systemGray6.cgColor

        titleLabel.text = "테스트 이슈 작성"
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16).isActive = true
        
        issueNumberLabel.text = "#2"
        issueNumberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        issueNumberLabel.textColor = .systemGray2
        issueNumberLabel.font = UIFont.systemFont(ofSize: 28)
        issueNumberLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        issueNumberLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        issueNumberLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor).isActive = true

        statusLabel.paddingTop = 6
        statusLabel.paddingLeft = 12
        statusLabel.paddingBottom = 6
        statusLabel.paddingRight = 12
        statusLabel.backgroundColor = UIColor(red: 0.782, green: 0.922, blue: 1, alpha: 1)
        statusLabel.layer.cornerRadius = 15
        statusLabel.layer.masksToBounds = true
        statusLabel.text = "열림"
        statusLabel.textColor = .systemBlue
        
        let attributedString = NSMutableAttributedString(string: "")
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "exclamation.png")
        
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(NSAttributedString(string: statusLabel.text ?? ""))
        statusLabel.attributedText = attributedString
        

        statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -19).isActive = true

        writerTimeLabel.text = "8분 전, Oni님이 작성했습니다."
        writerTimeLabel.font = UIFont.systemFont(ofSize: 13)
        writerTimeLabel.textColor = UIColor.systemGray2

        writerTimeLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 8).isActive = true
        writerTimeLabel.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor).isActive = true
        writerTimeLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor).isActive = true
        
        return headerView
    }
}

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentCell else {
            return CommentCell()
        }
        return cell
    }
}
