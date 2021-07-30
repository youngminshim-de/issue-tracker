import UIKit

protocol CommentTableViewCellDelegate: AnyObject {
    func CommentTableViewCellActionDidFinish(index: Int, sender: UIButton)
}

class CommentTableViewCell: UITableViewCell, Identifying {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var writeTime: UILabel!
    @IBOutlet weak var commentOption: UIButton!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var fileImage: UIImageView!
    
    var index: Int = 0
    weak var delegate: CommentTableViewCellDelegate?
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBAction func pressedEmojiButton(_ sender: Any) {
        self.delegate?.CommentTableViewCellActionDidFinish(index: self.index, sender: self.commentOption)
    }
    
}
