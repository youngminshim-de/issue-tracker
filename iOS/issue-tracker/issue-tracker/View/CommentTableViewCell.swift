import UIKit

class CommentTableViewCell: UITableViewCell, Identifying {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var writeTime: UILabel!
    @IBOutlet weak var commentOption: UIButton!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var fileImage: UIImageView!
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
