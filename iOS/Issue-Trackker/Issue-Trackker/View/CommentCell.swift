//
//  CommentCell.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/14.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var wrtierLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var writerImageView: UIImageView!
    
    func configureCommentCell(writer: String, time: String, comment: String, imageURL: String) {
        self.wrtierLabel.text = writer
        self.timeLabel.text = time
        self.commentLabel.text = comment
        self.writerImageView.load(url: imageURL)
    }
    
}
