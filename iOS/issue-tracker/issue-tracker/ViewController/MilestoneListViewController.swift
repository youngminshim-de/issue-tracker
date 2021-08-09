import UIKit
import Combine

class MilestoneListViewController: UIViewController, AdditionViewControllerDelegate {

    @IBOutlet weak var milestoneTabelView: UITableView!
    private let milestoneListViewModel = MilestoneListViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureTableViewFooterView()
        configureNavigationTitle()
        configureAddButton()
        milestoneTabelView.register(MilestoneTableViewCell.nib, forCellReuseIdentifier: MilestoneTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        milestoneListViewModel.fetchMilestoneList()
    }
    
    private func bind() {
        milestoneListViewModel.didUpdateMilestoneList()
            .sink { [weak self] _ in
                self?.milestoneTabelView.reloadData()
            }.store(in: &subscriptions)
        
        milestoneListViewModel.didUpdateResultMessage()
            .sink { [weak self] _ in
                self?.milestoneListViewModel.fetchMilestoneList()
            }.store(in: &subscriptions)
    }
    
    private func configureTableViewFooterView() {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        milestoneTabelView.tableFooterView = footerView
    }
    
    private func configureNavigationTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: UIFont.Weight(700))]
        self.navigationItem.title = "마일스톤"
    }
    
    private func configureAddButton() {
        let buttonImage = UIImage(systemName: "plus")
        let button = UIButton(type: .system)
        button.setImage(buttonImage, for: .normal)
        button.setTitle("추가 ", for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(showNewMilestoneView), for: .touchUpInside)
        let selectButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = selectButton
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "삭제", handler: { [weak self] (_, _, success) in
            self?.milestoneListViewModel.delete(indexPath: indexPath)
            success(true)
        })
        
        let trashCanImage = UIImage(systemName: "trash")
        action.image = trashCanImage
        
        let customRed = UIColor(red: 1, green: 59/255, blue: 48/255, alpha: 1)
        action.backgroundColor = customRed
        
        return action
    }
    
    private func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "편집", handler: { [weak self] (_, _, success) in
            guard let additionMilestoneViewController = self?.storyboard?.instantiateViewController(identifier: MilestoneAdditionViewController.identifier) as? MilestoneAdditionViewController,
                let milestone = self?.milestoneListViewModel.detailMilestone(indexPath: indexPath) else {
                return
            }
            
            additionMilestoneViewController.setExistingMilestone(milestone)
            additionMilestoneViewController.delegate = self
            self?.present(additionMilestoneViewController, animated: true, completion: nil)
            success(true)
        })
        
        let archiveBoxImage = UIImage(systemName: "square.and.pencil")
        action.image = archiveBoxImage
        
        let customBlue = UIColor(red: 204/255, green: 212/255, blue: 1, alpha: 1)
        action.backgroundColor = customBlue
        
        return action
    }
    
    func additionViewControllerDidFinish() {
        self.milestoneListViewModel.fetchMilestoneList()
    }
    
    @objc func showNewMilestoneView() {
        guard let additionMilestoneViewController = self.storyboard?.instantiateViewController(identifier: MilestoneAdditionViewController.identifier) as? MilestoneAdditionViewController else {
            return
        }
        additionMilestoneViewController.delegate = self
        self.present(additionMilestoneViewController, animated: true, completion: nil)
    }
    
}

extension MilestoneListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return milestoneListViewModel.detailMilestoneCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MilestoneTableViewCell.identifier, for: indexPath) as? MilestoneTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(detailMilestone: milestoneListViewModel.detailMilestone(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = deleteAction(at: indexPath)
        let editAction = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
}
