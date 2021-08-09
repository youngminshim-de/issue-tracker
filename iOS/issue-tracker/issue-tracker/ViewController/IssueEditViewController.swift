//
//  IssueEditViewController.swift
//  issue-tracker
//
//  Created by user on 2021/08/05.
//

import UIKit
import Combine

protocol IssueEditViewControllerDelegate: AnyObject {
    func issueEditViewControllerDidFinish()
}

class IssueEditViewController: UIViewController {

    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var issueTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    private var issueEditViewModel = IssueEditViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    weak var delegate: IssueEditViewControllerDelegate?
    private var containerViewDefaultHeight: CGFloat = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        self.issueTextField.text = self.issueEditViewModel.title()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animatePresentViewController()
        self.animateShowDimmedView()
    }
    
    private func animatePresentViewController() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewHeight.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateShowDimmedView() {
        let dimmedViewMaxAlpha: CGFloat = 0.6
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = dimmedViewMaxAlpha
        }
    }
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewHeight.constant = self.containerViewDefaultHeight
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func bind() {
        self.issueEditViewModel.didUpdateResultMessage()
            .sink { [weak self] resultMessage in
                if resultMessage != nil {
                    self?.animateDismissView()
                    self?.delegate?.issueEditViewControllerDidFinish()
                }
            }.store(in: &subscriptions)
        
        self.issueEditViewModel.didUpdateSaveButtonEnable()
            .sink { [weak self] isEnable in
                self?.saveButton.isEnabled = isEnable
            }.store(in: &subscriptions)
    }
    
    func setIssueInfo(issueID: Int?, title: String?) {
        self.issueEditViewModel.configureIssueTitle(title)
        self.issueEditViewModel.configureIssueID(issueID)
    }
    
    @IBAction func issueTextFieldAction(_ sender: UITextField) {
        issueEditViewModel.configureIssueTitle(sender.text)
    }
    
    @IBAction func pressedCancelButton(_ sender: UIButton) {
        animateDismissView()
    }
    
    @IBAction func pressedSaveButton(_ sender: UIButton) {
        self.issueEditViewModel.addNewIssueTitle()
    }
}

extension IssueEditViewController: Identifying { }
