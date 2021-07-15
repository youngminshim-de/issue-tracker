import UIKit
import Combine

class AdditionalInfoViewController: UIViewController {
    
    @IBOutlet weak var AddionalInfoTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let additionalInfoViewModel = AdditionalInfoViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
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
        
        self.additionalInfoViewModel.fetchAdditionalInfo()
    }

    private func configureAdditionalInfoTableView() {
        let infoType = self.additionalInfoViewModel.additionalInfoType()
        if infoType == .milestone {
            self.AddionalInfoTableView.allowsMultipleSelection = false
        } else {
            self.AddionalInfoTableView.allowsMultipleSelection = true
        }
    }
    
    private func configureTitle() {
        self.titleLabel.text = self.additionalInfoViewModel.additionalInfoType().rawValue
    }
    
    func setAdditionalInfoType(of info: AdditionalInfoViewModel.IssueAdditionalInfo) {
        self.additionalInfoViewModel.setInfoType(of: info)
    }
    
    @IBAction func pressedCancelButton(_ sender: UIButton) {
        
    }
    
    @IBAction func pressedSaveButton(_ sender: UIButton) {
        print(self.AddionalInfoTableView.indexPathsForSelectedRows)
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
    
}

extension AdditionalInfoViewController: Identifying { }
