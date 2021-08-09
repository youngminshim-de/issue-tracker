import UIKit
import Combine

class MilestoneAdditionViewController: UIViewController {

    @IBOutlet weak var additionView: AdditionView!
    
    weak var delegate: AdditionViewControllerDelegate?
    
    private var milestoneAdditionViewModel = MilestoneAdditionViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureMilestoneView()
        configureAddTarget()
        configureView()
    }
    
    private func bind() {
        milestoneAdditionViewModel.didUpdateResultMessage()
            .sink { [weak self] result in
                if result != nil {
                    self?.delegate?.additionViewControllerDidFinish()
                }
            }.store(in: &subscriptions)
        
        milestoneAdditionViewModel.didUpdateSaveButton()
            .sink { [weak self] result in
                self?.additionView.saveButton.isEnabled = result
            }.store(in: &subscriptions)
        
        milestoneAdditionViewModel.didUpdateCorrectDueDate()
            .sink { [weak self] result in
                switch result {
                case true:
                    self?.additionView.attributeTextField.textColor = .black
                case false:
                    self?.additionView.attributeTextField.textColor = .red
                }
            }.store(in: &subscriptions)
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
        self.additionView.titleTextField.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
        self.additionView.descriptionTextField.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
        self.additionView.attributeTextField.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
        self.additionView.saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        self.additionView.cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
    }
    
    func setExistingMilestone(_ milestone: DetailMilestone) {
        self.milestoneAdditionViewModel.configureExistingMilestone(milestone)
    }
    
    func configureView() {
        let milestone = self.milestoneAdditionViewModel.makeNewMilestoneDTO()
        self.additionView.titleTextField.text = milestone.title
        self.additionView.descriptionTextField.text = milestone.content
        self.additionView.attributeTextField.text = milestone.dueDate
    }
    
    @objc func textFieldAction(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        switch sender {
        case additionView.titleTextField:
            self.milestoneAdditionViewModel.configureTitle(text)
        case additionView.descriptionTextField:
            self.milestoneAdditionViewModel.configureDescription(text)
        case additionView.attributeTextField:
            self.milestoneAdditionViewModel.configureDueDate(text)
        default:
            break
        }
    }
    
    @objc func saveButtonAction() {
        self.milestoneAdditionViewModel.updateMildestone()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MilestoneAdditionViewController: Identifying { }
