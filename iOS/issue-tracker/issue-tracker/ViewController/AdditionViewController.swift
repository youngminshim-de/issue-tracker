import UIKit
import Combine

class AdditionViewController: UIViewController {

    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var attributeTitle: UILabel!
    @IBOutlet weak var attributeTextField: UITextField!
    @IBOutlet weak var randomColorButton: UIButton!
    @IBOutlet weak var labelPreview: UIView!
    @IBOutlet weak var labelBackgroundView: UIView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    private var additionLabelViewModel = AdditionLabelViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField()
        bind()
    }
    
    private func bind() {
        additionLabelViewModel.didUpdateSaveButton()
            .sink { [weak self] result in
                self?.saveButton.isEnabled = result
            }.store(in: &subscriptions)
        
        additionLabelViewModel.didUpdateCorrectColor()
            .sink { [weak self] result in
                switch result {
                case true:
                    self?.attributeTextField.textColor = .black
                case false:
                    self?.attributeTextField.textColor = .red
                }
            }.store(in: &subscriptions)
    }

    private func configureTextField() {
        self.titleTextField.delegate = self
        self.descriptionTextField.delegate = self
        self.attributeTextField.delegate = self
    }
    
    @IBAction func pressedRandomButton(_ sender: Any) {
        let randomColor = self.additionLabelViewModel.makeRandomColor()
        self.attributeTextField.text = randomColor
        if self.additionLabelViewModel.isColorDark() {
            self.labelText.textColor = .white
        } else {
            self.labelText.textColor = .black
        }
        self.labelBackgroundView.backgroundColor = UIColor(hex: randomColor)
    }
    
}

extension AdditionViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text ?? "") as NSString
        let newText = text.replacingCharacters(in: range, with: string)

        switch textField {
        case self.titleTextField:
            self.additionLabelViewModel.configureTitle(newText)
        case self.descriptionTextField:
            self.additionLabelViewModel.configureDescription(newText)
        case self.attributeTextField:
            self.additionLabelViewModel.configureBackgroundColor(newText)
        default:
            break
        }
        
        return true
    }
    
}
