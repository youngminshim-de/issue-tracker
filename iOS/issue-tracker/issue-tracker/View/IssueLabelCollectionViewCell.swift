//
//  IssueLabelCollectionViewCell.swift
//  issue-tracker
//
//  Created by user on 2021/08/05.
//

import UIKit

class IssueLabelCollectionViewCell: UICollectionViewCell, Identifying {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    private let titleLabel: UILabel = UILabel()
    
    func setupView() {
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.lineBreakMode = .byTruncatingMiddle
        titleLabel.numberOfLines = 1
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    static func fittingSize(height: CGFloat, name: String?) -> CGSize {
        let cell = IssueLabelCollectionViewCell()
        cell.configure(label: name)
        
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: height)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
    
    func configure(label: String?) {
        titleLabel.text = label
    }
    
}
