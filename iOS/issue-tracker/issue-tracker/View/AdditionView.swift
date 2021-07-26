import UIKit

class AdditionView: UIView {
    
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var attributeTextField: UITextField!
    @IBOutlet weak var randomColorButton: UIButton!
    @IBOutlet weak var labelPreview: UIView!
    @IBOutlet weak var labelBackgroundView: UIView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let nib = UINib(nibName: "AdditionView", bundle: Bundle.main)
        guard let xibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let nib = UINib(nibName: "AdditionView", bundle: Bundle.main)
        guard let xibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(xibView)
    }
    
}
