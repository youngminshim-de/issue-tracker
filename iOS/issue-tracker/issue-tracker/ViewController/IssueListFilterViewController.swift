import UIKit
import Combine

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
    
    private let filterViewModel = FilterViewModel()
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.tableFooterView = UIView()
        bind()
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

    @IBAction func pressedCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension IssueListFilterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableViewSection = Section.allCases[section]
        
        switch tableViewSection {
        case .isOpen:
            return 1
        case .userState:
            return 1
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
            cell.title.text = "열림닫힘"
        case .userState:
            cell.title.text = "유저 상태"
        case .writer:
            cell.title.text = filterViewModel.user(indexPath: indexPath)
        case .label:
            cell.title.text = filterViewModel.label(indexPath: indexPath)
        case .mileStone:
            cell.title.text = filterViewModel.milestone(indexPath: indexPath)
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
    
}

extension IssueListFilterViewController: Identifying { }
