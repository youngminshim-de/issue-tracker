//
//  IssueCellCollectionViewCell.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/09.
//

import UIKit

class IssueCell: UITableViewCell {
    
    @IBOutlet weak var issueTitleLabel: UILabel!
    @IBOutlet weak var issueDescriptionLabel: UILabel!
    @IBOutlet weak var milestoneLabel: UILabel!
    @IBOutlet weak var label: PaddingLabel!
    
    func configureIssueCell(title: String, milestone: String, label: String) {
        self.issueTitleLabel.text = title
        self.milestoneLabel.text = milestone
        self.label.text = label
        self.issueDescriptionLabel.text = "이슈에 대한 설명"
    }
}
