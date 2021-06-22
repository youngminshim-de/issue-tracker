//
//  CommentTableHeaderView.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/22.
//

import UIKit

class CommentTableHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private var titleLabel: UILabel!
    private var issueNumberLabel: UILabel!
    private var statusLabel: PaddingLabel!
    private var writerTimeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func makeHeaderView(title: String? = nil, issueNumber: String? = nil, status: String? = nil, writeTime: String? = nil) {

        titleLabel = UILabel()
        issueNumberLabel = UILabel()
        statusLabel = PaddingLabel()
        writerTimeLabel = UILabel()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        issueNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        writerTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(titleLabel)
        self.addSubview(issueNumberLabel)
        self.addSubview(statusLabel)
        self.addSubview(writerTimeLabel)

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray6.cgColor

        titleLabel.text = title
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        
        issueNumberLabel.text = issueNumber
        issueNumberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        issueNumberLabel.textColor = .systemGray2
        issueNumberLabel.font = UIFont.systemFont(ofSize: 28)
        issueNumberLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        issueNumberLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        issueNumberLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor).isActive = true

        statusLabel.backgroundColor = UIColor(red: 0.782, green: 0.922, blue: 1, alpha: 1)
        statusLabel.layer.cornerRadius = 15
        statusLabel.layer.masksToBounds = true
        statusLabel.text = status
        statusLabel.textColor = .systemBlue
        
        let attributedString = NSMutableAttributedString(string: "")
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "exclamation.png")
        
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(NSAttributedString(string: statusLabel.text ?? ""))
        statusLabel.attributedText = attributedString
        

        statusLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -19).isActive = true

        writerTimeLabel.text = writeTime
        writerTimeLabel.font = UIFont.systemFont(ofSize: 13)
        writerTimeLabel.textColor = UIColor.systemGray2

        writerTimeLabel.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 8).isActive = true
        writerTimeLabel.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor).isActive = true
        writerTimeLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor).isActive = true
    }
    
    func configureHeaderView(title: String? = nil, issueNumber: String? = nil, status: String? = nil, writeTime: String? = nil) {
        titleLabel.text = title
        issueNumberLabel.text = issueNumber
        writerTimeLabel.text = writeTime
        statusLabel.text = status
    }
}
