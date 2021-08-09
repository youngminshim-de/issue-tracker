import UIKit
import Combine

protocol AdditionalInfoViewControllerDelegate: AnyObject {
    func AdditionalInfoViewControllerDidFinish(additionalInfo: [AdditionalInfo], infoType: IssueAdditionalInfo)
}

class AdditionalInfoViewController: UIViewController {
    
    @IBOutlet weak var AddionalInfoTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    private let additionalInfoViewModel = AdditionalInfoViewModel()
    private var subscriptions = Set<AnyCancellable>()
    weak var delegate: AdditionalInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureTitle()
        configureAdditionalInfoTableView()
    }
    
    private func bind() {
        additionalInfoViewModel.didUpdateAdditionalInfo()
            .sink { [weak self] _ in
                self?.AddionalInfoTableView.reloadData()
            }.store(in: &subscriptions)
        
        additionalInfoViewModel.didUpdateSelectedInfo()
            .sink { [weak self] isEmpty in
                self?.saveButton.isEnabled = !isEmpty
            }.store(in: &subscriptions)
        
        self.additionalInfoViewModel.fetchAdditionalInfo()
    }
    
    private func configureTableViewFooterView() {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        AddionalInfoTableView.tableFooterView = footerView
    }

    private func configureAdditionalInfoTableView() {
        let infoType = self.additionalInfoViewModel.additionalInfoType()
        if infoType == .milestone {
            self.AddionalInfoTableView.allowsMultipleSelection = false
        } else {
            self.AddionalInfoTableView.allowsMultipleSelection = true
        }
        configureTableViewFooterView()
    }
    
    private func configureTitle() {
        self.titleLabel.text = self.additionalInfoViewModel.additionalInfoType().rawValue
    }
    
    func setAdditionalInfoType(of info: IssueAdditionalInfo) {
        self.additionalInfoViewModel.setInfoType(of: info)
    }
    
    @IBAction func pressedCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedSaveButton(_ sender: UIButton) {
        delegate?.AdditionalInfoViewControllerDidFinish(additionalInfo: additionalInfoViewModel.seletedAdditionalInfo(), infoType: additionalInfoViewModel.additionalInfoType())
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AdditionalInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.additionalInfoViewModel.additionalInfoCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as? FilterTableViewCell else {
            return UITableViewCell()
        }
        
        cell.title.text = additionalInfoViewModel.additionalInfo(indexPath: indexPath).title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.additionalInfoViewModel.updateSeletedInfo(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.additionalInfoViewModel.deleteSeletedInfo(indexPath: indexPath)
    }
    
}

extension AdditionalInfoViewController: Identifying { }
