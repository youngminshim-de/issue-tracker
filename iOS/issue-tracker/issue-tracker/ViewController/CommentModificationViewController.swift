import UIKit

class CommentModificationViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var fileNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
    }
    @IBAction func pressedCancelButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func pressedSaveButton(_ sender: UIButton) {
        print("aewef")
    }
    
    @IBAction func pressedUpload(_ sender: UIButton) {
        print("hello")
    }
    
}

extension CommentModificationViewController: Identifying { }
