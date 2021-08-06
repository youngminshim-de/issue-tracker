import UIKit

class IssueTableViewCell: UITableViewCell, Identifying {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var milestone: UILabel!
    @IBOutlet weak var labelCollectionView: UICollectionView!
    @IBOutlet weak var labelCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var checkImage: UIImageView!
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    var labels: [Label]? {
        didSet {
            self.labelCollectionView.reloadData()
            let height = self.labelCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.labelCollectionViewHeight.constant = height
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelCollectionView.register(IssueLabelCollectionViewCell.nib, forCellWithReuseIdentifier: IssueLabelCollectionViewCell.identifier)
        labelCollectionView.dataSource = self
        labelCollectionView.delegate = self
        
        let flowLayout = CollectionViewLeftAlignFlowLayout()
        labelCollectionView.collectionViewLayout = flowLayout
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let ivoryColor = UIColor(hex: "#FFFEFC")
        contentView.backgroundColor = selected ? ivoryColor : .white
        self.checkImage.isHidden = !selected
    }
    
    func configure(issue: Issue) {
        title.text = issue.title
        content.text = issue.comment
        milestone.attributedText = issue.milestone == "" ? NSAttributedString(string: "") : makeMilestoneAttributedString(issue.milestone)
        labels = issue.labels
    }
    
    private func makeMilestoneAttributedString(_ string: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: "")
        let imageAttachment = NSTextAttachment()
        let padding = "  "
        imageAttachment.image = UIImage(named: "mileStoneImage")
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append((NSAttributedString(string: "\(padding)\(string)")))
        
        return attributedString
    }
    
}

extension IssueTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.labels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IssueLabelCollectionViewCell.identifier, for: indexPath) as? IssueLabelCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = UIColor(hex: self.labels?[indexPath.row].color ?? "#FFFFFF")
        cell.configure(label: labels?[indexPath.row].title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let targetSize = IssueLabelCollectionViewCell.fittingSize(height: 35, name: labels?[indexPath.item].title)
        
        return targetSize
    }
    
}
