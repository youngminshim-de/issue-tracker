import UIKit
import Combine

class IssueSelectionViewController: UIViewController {

    @IBOutlet weak var issueTableView: UITableView!
    @IBOutlet weak var allSelectionButton: UIButton!
    @IBOutlet weak var issueCloseButton: UIButton!
    @IBOutlet weak var selectedIssueCountLabel: UILabel!
    private var issueSelectionViewModel = IssueSelectionViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureTableView()
        configureButton()
        configureNavigationTitle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func bind() {
        issueSelectionViewModel.didUpdateIssueList()
            .sink { [weak self] _ in
                self?.issueTableView.reloadData()
            }.store(in: &subscriptions)
        
        issueSelectionViewModel.didUpdateResultMessage()
            .sink { [weak self] resultMessage in
                if resultMessage != nil {
                    print(resultMessage)
                    self?.navigationController?.popViewController(animated: false)
                }
            }.store(in: &subscriptions)
        
        issueSelectionViewModel.didUpdateSelectedIssueInfo()
            .sink { [weak self] selectedIssueInfo in
                self?.selectedIssueCountLabel.text = selectedIssueInfo
            }.store(in: &subscriptions)
        
        issueSelectionViewModel.didUpdateIsAllSelected()
            .sink { [weak self] isAllSelected in
                self?.allSelectionButton.isSelected = isAllSelected
            }.store(in: &subscriptions)
        
        issueSelectionViewModel.didUpdateIsCloseable()
            .sink { [weak self] isCloseable in
                self?.issueCloseButton.isEnabled = isCloseable
            }.store(in: &subscriptions)
    }
    
    private func configureTableView() {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        issueTableView.tableFooterView = footerView
        
        issueTableView.allowsMultipleSelection = true
        issueTableView.register(IssueTableViewCell.nib, forCellReuseIdentifier: IssueTableViewCell.identifier)
    }
    
    private func configureNavigationTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: UIFont.Weight(700))]
        self.navigationItem.title = "이슈 선택"
    }
    
    private func configureButton() {
        let button = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(pressedCancelButton))
        button.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight(600))], for: .normal)
        self.navigationItem.rightBarButtonItem = button
        
        allSelectionButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
    }
    
    func setExistingIssues(_ issues: IssueList) {
        self.issueSelectionViewModel.setIssues(issues)
    }
    
    @objc func pressedCancelButton() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func pressedAllSelectButton(_ sender: UIButton) {
        let rowCount = issueTableView.numberOfRows(inSection: 0)

        if sender.state == .highlighted {
            for index in 0..<rowCount {
                self.issueTableView.selectRow(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .none)
            }
            self.issueSelectionViewModel.selectAll()
        } else {
            for index in 0..<rowCount {
                self.issueTableView.deselectRow(at: IndexPath.init(row: index, section: 0), animated: true)
            }
            self.issueSelectionViewModel.deselectAll()
        }
    }
    
    @IBAction func pressedCloseButton(_ sender: UIButton) {
        self.issueSelectionViewModel.closeIssues()
    }
    
}

extension IssueSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.issueSelectionViewModel.issueCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IssueTableViewCell.identifier, for: indexPath) as? IssueTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(issue: issueSelectionViewModel.issue(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.issueSelectionViewModel.updateSelectdIssue(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.issueSelectionViewModel.deleteSelectedIssue(indexPath: indexPath)
    }
    
}

extension IssueSelectionViewController: Identifying { }
