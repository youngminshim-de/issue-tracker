import UIKit
import Combine

class LabelAdditionViewController: UIViewController {

    @IBOutlet weak var additionView: AdditionView!
    
    private var labelAdditionViewModel = LabelAdditionViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAddTarget()
        bind()
    }
    
    private func bind() {
        labelAdditionViewModel.didUpdateSaveButton()
            .sink { [weak self] result in
                self?.additionView.saveButton.isEnabled = result
            }.store(in: &subscriptions)
        
        labelAdditionViewModel.didUpdateCorrectColor()
            .sink { [weak self] result in
                switch result {
                case true:
                    self?.additionView.attributeTextField.textColor = .black
                case false:
                    self?.additionView.attributeTextField.textColor = .red
                }
            }.store(in: &subscriptions)
        
        labelAdditionViewModel.didUpdateBackgroundColor()
            .sink { [weak self] color in
                if self?.labelAdditionViewModel.isColorDark() == true {
                    self?.additionView.labelText.textColor = .white
                } else {
                    self?.additionView.labelText.textColor = .black
                }
                self?.additionView.labelBackgroundView.backgroundColor = UIColor(hex: color)
            }.store(in: &subscriptions)
    }
    
    func configureAddTarget() {
        self.additionView.titleTextField.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
        self.additionView.descriptionTextField.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
        self.additionView.attributeTextField.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
        self.additionView.randomColorButton.addTarget(self, action: #selector(randomButtonAction), for: .touchUpInside)
        self.additionView.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        self.additionView.cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
    }
    
    @objc func textFieldAction(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        switch sender {
        case additionView.titleTextField:
            self.labelAdditionViewModel.configureTitle(text)
        case additionView.descriptionTextField:
            self.labelAdditionViewModel.configureDescription(text)
        case additionView.attributeTextField:
            self.labelAdditionViewModel.configureBackgroundColor(text)
        default:
            break
        }
    }
    
    @objc func randomButtonAction() {
        let randomColor = self.labelAdditionViewModel.makeRandomColor()
        self.additionView.attributeTextField.text = randomColor
    }
    
    @objc func saveButtonAction() {
        self.labelAdditionViewModel.addNewLabel()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LabelAdditionViewController: Identifying { }
