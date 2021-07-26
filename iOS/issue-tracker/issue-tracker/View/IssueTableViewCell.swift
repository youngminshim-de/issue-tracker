import UIKit

class IssueTableViewCell: UITableViewCell, Identifying {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var milestone: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
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
        milestone.text = issue.milestone
        label.text = issue.labels.first?.title
        label.backgroundColor = UIColor(hex: issue.labels.first?.color ?? "#FFFFFF")
    }
    
}
