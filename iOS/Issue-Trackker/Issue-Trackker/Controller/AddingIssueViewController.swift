//
//  AddingIssueViewController.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/11.
//

import UIKit
import Alamofire

class AddingIssueViewController: UIViewController {

    @IBOutlet weak var additionalInformationTableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private var issue: AddingIssue
    private var networkManager: NetworkManager
    private var requestable: Requestable
    private var decoder: JSONDecoder
        
    override func viewDidLoad() {
        super.viewDidLoad()
        additionalInformationTableView.tableHeaderView = makeTableHeaderView()
        configureNavigationItem()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.issue = AddingIssue.empty
        self.requestable = IssueListRequest(baseURL: EndPoint.IssueListEndPoint.description, path: "", httpMethod: .post)
        self.decoder = JSONDecoder()
        self.networkManager = NetworkManager(with: AF, with: requestable, with: decoder)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.issue = AddingIssue.empty
        self.requestable = IssueListRequest(baseURL: EndPoint.IssueListEndPoint.description, path: "", httpMethod: .post)
        self.decoder = JSONDecoder()
        self.networkManager = NetworkManager(with: AF, with: requestable, with: decoder)
        super.init(coder: coder)
    }
    
    private func addIssue() {
        networkManager.post(parameter: makeParameter(), completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    private func configureNavigationItem() {
        let leftButton = UIButton.makeButton(image: "Icon.png", title: " 취소")
        leftButton.addTarget(self, action: #selector(backButtonTouched(_ :)), for: .touchUpInside)
        
        let rightButton = UIButton.makeButton(image: "plus.png", title: " 저장")
        rightButton.semanticContentAttribute = .forceRightToLeft
        rightButton.addTarget(self, action: #selector(saveButtonTouched(_:)), for: .touchUpInside)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    private func makeTableHeaderView() -> UIView {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.additionalInformationTableView.frame.width, height: 44)))
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "추가 정보"
        label.font = .boldSystemFont(ofSize: 22)
        view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        return view
    }
    
    private func makeParameter() -> Parameters {
        let parameter: Parameters = [
            "title" : issue.title,
            "text" : issue.text,
            "assignments" : [],
            "labels" : [],
            "milestone" : 1
        ]
        return parameter
    }
    
    @objc func backButtonTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTouched(_ sender: UIButton) {
        addIssue()
    }
    
    @IBAction func segmentControlTouched(_ sender: UISegmentedControl) {
    }
}

extension AddingIssueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AdditionalInformation.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInformationCell") as? AdditionalInformationCell else {
            return AdditionalInformationCell()
        }
        
        cell.configureAdditionalInformationCell(information: AdditionalInformation.allCases[indexPath.row].description)
        return cell
    }
}

extension AddingIssueViewController: UITextFieldDelegate {
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.issue.title = textField.text ?? ""
    }
}

extension AddingIssueViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.issue.text = textView.text
    }
}

enum AdditionalInformation: CustomStringConvertible, CaseIterable {
    case label, milestone, asignee
    
    var description: String {
        switch self {
        case .label:
            return "레이블"
        case .milestone:
            return "마일스톤"
        case .asignee:
            return "담당자"
        }
    }
}
