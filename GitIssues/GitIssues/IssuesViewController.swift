//
//  IssuesViewController.swift
//  GitIssues
//
//  Created by John Penning on 12/3/21.
//

import UIKit

class IssuesViewController: UITableViewController {

    var issues = [Issue]()
    var currentPage = 1
    var isFetchInProgress = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.prefetchDataSource = self

        // Add pull-to-refresh
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshIssues), for: .valueChanged)

        fetchIssueData()
    }

    @objc func refreshIssues() {
        issues.removeAll()
        currentPage = 1
        fetchIssueData()
    }

    private func calculateIndexPathsToReload(from newIssues: [Issue]) -> [IndexPath] {
        let startIndex = issues.count - newIssues.count
        let endIndex = startIndex + newIssues.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }

    func fetchIssueData() {
        guard !isFetchInProgress else {
            return
        }

        isFetchInProgress = true
        Issue.fetch(page: currentPage) { [weak self] newIssues in

            defer {
                self?.isFetchInProgress = false
                self?.refreshControl?.endRefreshing()
            }

            guard let newIssues = newIssues, !newIssues.isEmpty else {
                return
            }
            self?.issues.append(contentsOf: newIssues)
            if self?.currentPage ?? 1 > 1 {
                let newIndexPaths = self?.calculateIndexPathsToReload(from: newIssues) ?? []
                let indexPathstoReload = self?.visibleIndexPathsToReload(intersecting: newIndexPaths) ?? []
                self?.tableView.reloadRows(at: indexPathstoReload, with: .automatic)
            } else {
                self?.tableView.reloadData()
            }
            self?.currentPage += 1
        }
    }

    // UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Issue", for: indexPath)

        if isLoadingCell(for: indexPath) {
            return UITableViewCell()
        } else {
            let issue = issues[indexPath.row]
            cell.textLabel?.text = issue.title
            cell.detailTextLabel?.text = detailLabel(for: issue)
        }

        return cell
    }

    func detailLabel(for issue: Issue) -> String {
        switch issue.state {
        case .open:
            return "#\(issue.number) opened on \(issue.openedDate.formatted()) by \(issue.user.login)"
        case .closed:
            var label = "#\(issue.number) by \(issue.user.login) was closed"
            label += (issue.closedDate != nil) ? " on \(issue.closedDate!.formatted())" : ""
            return label
        }
    }

    // UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Comments") as? CommentsViewController {
            vc.issue = issues[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension IssuesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            fetchIssueData()
        }
    }
}

private extension IssuesViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= issues.count
    }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
