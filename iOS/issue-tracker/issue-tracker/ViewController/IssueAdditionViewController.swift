import UIKit
import MarkdownView

class IssueAdditionViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var markdownTextView: UITextView!
    @IBOutlet weak var markdownPreView: UIView!
    private var markdownView: MarkdownView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureMarkdownView() {
        markdownView = MarkdownView()
        guard let view = markdownView else {
            return
        }
        view.load(markdown: markdownTextView.text)
        markdownPreView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: markdownTextView.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: markdownTextView.rightAnchor).isActive = true
        view.topAnchor.constraint(equalTo: markdownTextView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: markdownTextView.bottomAnchor).isActive = true
    }
    
    @IBAction func pressedCancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func pressedSegmentedControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            markdownView?.removeFromSuperview()
            markdownView = nil
            markdownPreView.isHidden = true
            markdownTextView.isHidden = false
        case 1:
            markdownPreView.isHidden = false
            markdownTextView.isHidden = true
            configureMarkdownView()
        default:
            break
        }
    }
    
}
