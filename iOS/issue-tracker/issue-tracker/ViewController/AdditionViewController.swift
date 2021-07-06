import UIKit
import Combine

class AdditionViewController: UIViewController {

    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var backgroundColorLabel: UILabel!
    @IBOutlet weak var backgroundColorTextField: UITextField!
    @IBOutlet weak var randomColorButton: UIButton!
    @IBOutlet weak var labelPreview: UIView!
    @IBOutlet weak var labelBackgroundView: UIView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    private var additionLabelViewModel = AdditionLabelViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    self?.backgroundColorTextField.textColor = .black
                case false:
                    self?.backgroundColorTextField.textColor = .red
                }
            }.store(in: &subscriptions)
        
        additionLabelViewModel.didUpdateBackgroundColor()
            .sink { [weak self] color in
                if self?.additionLabelViewModel.isColorDark() == true {
                    self?.labelText.textColor = .white
                } else {
                    self?.labelText.textColor = .black
                }
                self?.labelBackgroundView.backgroundColor = UIColor(hex: color)
            }.store(in: &subscriptions)
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        switch sender {
        case titleTextField:
            self.additionLabelViewModel.configureTitle(text)
        case descriptionTextField:
            self.additionLabelViewModel.configureDescription(text)
        case backgroundColorTextField:
            self.additionLabelViewModel.configureBackgroundColor(text)
        default:
            break
        }
    }
    
    @IBAction func pressedRandomButton(_ sender: Any) {
        let randomColor = self.additionLabelViewModel.makeRandomColor()
        self.backgroundColorTextField.text = randomColor
    }
    
    @IBAction func pressedSaveButton(_ sender: Any) {
        self.additionLabelViewModel.addNewLabel()
        self.dismiss(animated: true, completion: nil)
    }
    
}
