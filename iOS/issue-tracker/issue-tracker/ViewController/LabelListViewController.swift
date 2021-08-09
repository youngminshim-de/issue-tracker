import UIKit
import Combine

class LabelListViewController: UIViewController, AdditionViewControllerDelegate {

    @IBOutlet weak var labelTableView: UITableView!
    private let labelListViewModel = LabelListViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureTableViewFooterView()
        configureNavigationTitle()
        configureAddButton()
        labelTableView.register(LabelTableViewCell.nib, forCellReuseIdentifier: LabelTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        labelListViewModel.fetchLabelList()
    }
    
    private func bind() {
        labelListViewModel.didUpdateLabelList()
            .sink { [weak self] _ in
                self?.labelTableView.reloadData()
            }.store(in: &subscriptions)
        
        labelListViewModel.didUpdateResultMessage()
            .sink { [weak self] _ in
                self?.labelListViewModel.fetchLabelList()
            }.store(in: &subscriptions)
        
        labelListViewModel.fetchLabelList()
    }
    
    private func configureTableViewFooterView() {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        labelTableView.tableFooterView = footerView
    }
    
    private func configureNavigationTitle() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: UIFont.Weight(700))]
        self.navigationItem.title = "레이블"
    }
    
    private func configureAddButton() {
        let buttonImage = UIImage(systemName: "plus")
        let button = UIButton(type: .system)
        button.setImage(buttonImage, for: .normal)
        button.setTitle("추가 ", for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(showNewLabelView), for: .touchUpInside)
        let selectButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = selectButton
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "삭제", handler: { [weak self] (_, _, success) in
            self?.labelListViewModel.delete(indexPath: indexPath)
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
            guard let additionLabelViewController = self?.storyboard?.instantiateViewController(identifier: LabelAdditionViewController.identifier) as? LabelAdditionViewController,
                let label = self?.labelListViewModel.detailLabel(indexPath: indexPath) else {
                return
            }
            
            additionLabelViewController.setExistingLabel(label)
            additionLabelViewController.delegate = self
            self?.present(additionLabelViewController, animated: true, completion: nil)
            success(true)
        })
        
        let archiveBoxImage = UIImage(systemName: "square.and.pencil")
        action.image = archiveBoxImage
        
        let customBlue = UIColor(red: 204/255, green: 212/255, blue: 1, alpha: 1)
        action.backgroundColor = customBlue
        
        return action
    }
    
    func additionViewControllerDidFinish() {
        self.labelListViewModel.fetchLabelList()
    }
    
    @objc func showNewLabelView() {
        guard let additionLabelViewController = self.storyboard?.instantiateViewController(identifier: LabelAdditionViewController.identifier) as? LabelAdditionViewController else {
            return
        }
        additionLabelViewController.delegate = self
        self.present(additionLabelViewController, animated: true, completion: nil)
    }
    
}

extension LabelListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelListViewModel.detailLabelCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LabelTableViewCell.identifier, for: indexPath) as? LabelTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(detailLabel: labelListViewModel.detailLabel(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = deleteAction(at: indexPath)
        let editAction = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
}
