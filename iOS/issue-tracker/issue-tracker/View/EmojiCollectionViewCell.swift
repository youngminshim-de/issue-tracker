//
//  EmojiCollectionViewCell.swift
//  issue-tracker
//
//  Created by user on 2021/08/05.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell, Identifying {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emojiLabel: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var emojiSize: CGSize = CGSize(width: 50, height: 30)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainView.layer.backgroundColor = UIColor.systemGray6.cgColor
    }

}
