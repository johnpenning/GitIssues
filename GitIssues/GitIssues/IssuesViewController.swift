//
//  IssuesViewController.swift
//  GitIssues
//
//  Created by John Penning on 12/3/21.
//

import UIKit

class IssuesViewController: UITableViewController {

    var issues: [Issue]?

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchIssueData()
    }

    func fetchIssueData() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.issues = Issue.fetch()
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    // UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues?.count ?? 0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let issues = issues else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "Issue", for: indexPath)

        let issue = issues[indexPath.row]
        cell.textLabel?.text = issue.title
        cell.detailTextLabel?.text = detailLabel(for: issue)

        return cell
    }

    func detailLabel(for issue: Issue) -> String {
        switch issue.state {
        case .open:
            return "#\(issue.number) opened on \(issue.openedDate) by \(issue.user.login)"
        case .closed:
            var label = "#\(issue.number) by \(issue.user.login) was closed"
            label += (issue.closedDate != nil) ? " on \(issue.closedDate!)" : ""
            return label
        }
    }
}

