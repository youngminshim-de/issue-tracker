//
//  CommentViewController.swift
//  Issue-Trackker
//
//  Created by 심영민 on 2021/06/14.
//

import UIKit
import Alamofire

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentTableView: UITableView!
    private var tableHeaderView: CommentTableHeaderView!
    
    private var issueDetail: IssueDetail
    private var networkManager: NetworkManager
    private var requestable: Requestable
    private var decoder: JSONDecoder
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.requestable = MainRequest(baseURL: EndPoint.IssueDetailEndPoint.description, path: "1", httpMethod: .get)
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.networkManager = NetworkManager(with: AF, with: requestable, with: decoder)
        self.issueDetail = IssueDetail.empty
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.requestable = MainRequest(baseURL: EndPoint.IssueDetailEndPoint.description, path: "1", httpMethod: .get)
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.networkManager = NetworkManager(with: AF, with: requestable, with: decoder)
        self.issueDetail = IssueDetail.empty
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureTextField()
        configureTableHeaderView()
        fetchIssueDetail()
    }
    
    func fetchIssueDetail() {
        networkManager.request(dataType: IssueDetail.self, completion: { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                self.issueDetail = data
                self.tableHeaderView.configureHeaderView(title: self.issueDetail.title,
                                                         issueNumber: self.issueDetail.idDescription,
                                                         status: self.issueDetail.statusDescription,
                                                         writeTime: self.issueDetail.writeTimeDescription)
                self.commentTableView.reloadData()
            }
        })
    }
    
    func configureTableHeaderView() {
        self.tableHeaderView = CommentTableHeaderView.init(frame: CGRect(origin: self.view.frame.origin, size: CGSize(width: self.view.bounds.width, height: 115)))
        self.tableHeaderView.makeHeaderView()
        self.commentTableView.tableHeaderView = tableHeaderView
        self.commentTableView.tableHeaderView?.backgroundColor = .white
    }
    
    private func configureNavigationItem() {
        let leftButton = UIButton.makeButton(image: "Icon.png", title: " 목록")
        leftButton.addTarget(self, action: #selector(backButtonTouched(_ :)), for: .touchUpInside)
        
        let rightButton = UIButton.makeButton(image: "more.png", title: "")
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    func configureTextField() {
        let sendButton = UIButton()
        sendButton.setImage(UIImage(named: "ButtonSend.png"), for: .normal)
        commentTextField.rightView = sendButton
        commentTextField.rightViewMode = .always
    }
    
    @objc func backButtonTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issueDetail.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentCell else {
            return CommentCell()
        }
        let writer = issueDetail.comments[indexPath.row].name
        let time = issueDetail.comments[indexPath.row].writeTime
        let comment = issueDetail.comments[indexPath.row].text
        let imageURL = issueDetail.comments[indexPath.row].avatarImage
        
        cell.configureCommentCell(writer: writer, time: time, comment: comment, imageURL: imageURL)
        return cell
    }
}
