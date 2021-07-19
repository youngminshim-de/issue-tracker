import UIKit
import Combine
import MarkdownView

class IssueAdditionViewController: UIViewController, AdditionalInfoViewControllerDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var markdownTextView: UITextView!
    @IBOutlet weak var markdownPreView: UIView!
    @IBOutlet var addtionButtons: [UIButton]!
    @IBOutlet var seletedLabels: [UILabel]!
    
    private var markdownView: MarkdownView?
    private let issueAdditionViewModel = IssueAdditionViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureSaveButtonColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func bind() {
        issueAdditionViewModel.didUpdateSaveButton()
            .sink { [weak self] isEnable in
                self?.saveButton.isEnabled = isEnable
            }.store(in: &subscriptions)
        
        issueAdditionViewModel.didUpdateLabels()
            .sink { [weak self] label in
                self?.seletedLabels[0].text = label.first?.title
            }.store(in: &subscriptions)
        
        issueAdditionViewModel.didUpdateMilestones()
            .sink { [weak self] milestone in
                self?.seletedLabels[1].text = milestone.first?.title
            }.store(in: &subscriptions)
        
        issueAdditionViewModel.didUpdateAssignees()
            .sink { [weak self] assignee in
                self?.seletedLabels[2].text = assignee.first?.title
            }.store(in: &subscriptions)
    }
    
    private func configureSaveButtonColor() {
        self.saveButton.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.5), for: .disabled)
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
    
    private func makeAdditionalViewController() -> AdditionalInfoViewController {
        guard let additionalInfoViewController = self.storyboard?.instantiateViewController(identifier: AdditionalInfoViewController.identifier) as? AdditionalInfoViewController else {
            return AdditionalInfoViewController()
        }
        return additionalInfoViewController
    }
    
    func AdditionalInfoViewControllerDidFinish(additionalInfo: [AdditionalInfo], infoType: AdditionalInfoViewModel.IssueAdditionalInfo) {
        self.issueAdditionViewModel.setAdditionalInfo(additionalInfo, infoType: infoType)
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
    
    @IBAction func pressedAdditionButton(_ sender: UIButton) {
        guard let additionalInfoViewController = self.storyboard?.instantiateViewController(identifier: AdditionalInfoViewController.identifier) as? AdditionalInfoViewController else {
            return
        }

        switch sender {
        case self.addtionButtons[0]:
            additionalInfoViewController.setAdditionalInfoType(of: .label)
        case self.addtionButtons[1]:
            additionalInfoViewController.setAdditionalInfoType(of: .milestone)
        case self.addtionButtons[2]:
            additionalInfoViewController.setAdditionalInfoType(of: .assignee)
        default:
            break
        }
        additionalInfoViewController.delegate = self
        self.present(additionalInfoViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func editTitle(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        self.issueAdditionViewModel.configureTitle(text)
    }
    
}

extension IssueAdditionViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else {
            return
        }
        self.issueAdditionViewModel.configureComment(text)
    }
}
