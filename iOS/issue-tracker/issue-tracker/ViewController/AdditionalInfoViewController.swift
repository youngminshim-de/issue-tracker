import UIKit
import Combine

class AdditionalInfoViewController: UIViewController {

    @IBOutlet weak var AddionalInfoTableView: UITableView!
    
    private let additionalInfoViewModel = AdditionalInfoViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        additionalInfoViewModel.didUpdateAdditionalInfo()
            .sink { [weak self] _ in
                self?.AddionalInfoTableView.reloadData()
            }.store(in: &subscriptions)
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
        
    }
    
}
extension AdditionalInfoViewController: Identifying { }
