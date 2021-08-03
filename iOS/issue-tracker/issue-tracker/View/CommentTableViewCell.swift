import UIKit

class CommentTableViewCell: UITableViewCell, Identifying {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var writeTime: UILabel!
    @IBOutlet weak var commentOption: UIButton!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    private let imageViewDefaultHeight: CGFloat = 160
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func setHeightZero() {
        self.imageViewHeight.constant = 0
    }
    
    func setDefaultHeight() {
        self.imageViewHeight.constant = self.imageViewDefaultHeight
    }
    
}
