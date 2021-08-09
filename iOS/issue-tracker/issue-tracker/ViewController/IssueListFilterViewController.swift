import UIKit
import Combine

protocol IssueListFilterViewControllerDelegate: AnyObject {
    func IssueListFilterViewControllerDidFinish(filterCondition: FilterCondition)
}

class IssueListFilterViewController: UIViewController {

    enum Section: Int, CaseIterable {
        case isOpen, userState, writer, label, mileStone
        
        func sectionDescription() -> String {
            switch self {
            case .isOpen:
                return "이슈 상태"
            case .userState:
                return "사용자 관련 이슈"
            case .writer:
                return "작성자"
            case .label:
                return "레이블"
            case .mileStone:
                return "마일스톤"
            }
        }
    }
    
    @IBOutlet weak var filterTableView: UITableView!
    weak var delegate: IssueListFilterViewControllerDelegate?
    
    private let filterViewModel = FilterViewModel()
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        filterTableView.tableFooterView = UIView()
        filterTableView.allowsMultipleSelection = true
    }
    
    private func bind() {
        self.filterViewModel.didUpdateUserList()
            .sink { [weak self] _ in
                self?.filterTableView.reloadData()
            }.store(in: &subscriptions)
        
        self.filterViewModel.didUpdateLabelList()
            .sink { [weak self] _ in
                self?.filterTableView.reloadData()
            }.store(in: &subscriptions)
        
        self.filterViewModel.didUpdateMilestoneList()
            .sink { [weak self] _ in
                self?.filterTableView.reloadData()
            }.store(in: &subscriptions)
        
        self.filterViewModel.fetchAllLists()
    }
    
    private func makeHeaderView(section: Int) -> UIView {
        let headerView = UIView(frame: .zero)
        let customGray = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        headerView.backgroundColor = customGray
        
        let label = UILabel(frame: .zero)
        let customDarkGray = UIColor(red: 135/255, green: 135/255, blue: 141/255, alpha: 1)
        label.textColor = customDarkGray
        headerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.text = Section.allCases[section].sectionDescription()
        return headerView
    }
    
    @IBAction func pressedSaveButton(_ sender: UIButton) {
        self.delegate?.IssueListFilterViewControllerDidFinish(filterCondition: filterViewModel.makeFilterCondition())
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func pressedCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension IssueListFilterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableViewSection = Section.allCases[section]
        
        switch tableViewSection {
        case .isOpen:
            return self.filterViewModel.isOpenCount()
        case .userState:
            return self.filterViewModel.userStateCount()
        case .writer:
            return self.filterViewModel.userCount()
        case .label:
            return self.filterViewModel.labelCount()
        case .mileStone:
            return self.filterViewModel.milestoneCount()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier, for: indexPath) as? FilterTableViewCell else {
            return UITableViewCell()
        }
        
        let tableViewSection = Section.allCases[indexPath.section]
        
        switch tableViewSection {
        case .isOpen:
            cell.title.text = self.filterViewModel.isOpen(indexPath: indexPath)
        case .userState:
            cell.title.text = self.filterViewModel.userState(indexPath: indexPath)
        case .writer:
            cell.title.text = self.filterViewModel.user(indexPath: indexPath)
        case .label:
            cell.title.text = self.filterViewModel.label(indexPath: indexPath)
        case .mileStone:
            cell.title.text = self.filterViewModel.milestone(indexPath: indexPath)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return makeHeaderView(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightForRowAt: CGFloat = 44
        return heightForRowAt
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let indexPaths = tableView.indexPathsForSelectedRows else { return }
        let section = Section.allCases[indexPath.section]
        let filteredIndexPaths = indexPaths.filter({ $0.section == indexPath.section && $0.row != indexPath.row })
        if !filteredIndexPaths.isEmpty {
            tableView.deselectRow(at: filteredIndexPaths[0], animated: false)
        }
        filterViewModel.addFilterCondition(section: section, row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let section = Section.allCases[indexPath.section]
        filterViewModel.deleteFilterCondition(section: section, row: indexPath.row)
    }
}

extension IssueListFilterViewController: Identifying { }
