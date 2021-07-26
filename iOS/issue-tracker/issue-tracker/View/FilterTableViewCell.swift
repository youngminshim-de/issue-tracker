import UIKit

class FilterTableViewCell: UITableViewCell, Identifying {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.checkImage.isHidden = !selected
    }
    
}
