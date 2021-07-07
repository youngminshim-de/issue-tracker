import UIKit
import Combine

class MilestoneAdditionViewController: UIViewController {

    @IBOutlet weak var additionView: AdditionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMilestoneView()
        configureAddTarget()
    }
    
    func configureMilestoneView() {
        self.additionView.viewTitle.text = "새로운 마일스톤"
        self.additionView.attributeLabel.text = "완료일"
        self.additionView.attributeTextField.text = ""
        self.additionView.attributeTextField.placeholder = "YYYY-MM-DD(선택사항)"
        self.additionView.labelPreview.isHidden = true
        self.additionView.randomColorButton.isHidden = true
    }
    
    func configureAddTarget() {
        self.additionView.cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
    }
    
    @objc func cancelButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MilestoneAdditionViewController: Identifying { }
