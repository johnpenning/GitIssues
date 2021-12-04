//
//  CommentsViewController.swift
//  GitIssues
//
//  Created by John Penning on 12/3/21.
//

import Foundation
import UIKit

class CommentsViewController: UITableViewController {

    var issue: Issue?
    var comments: [Comment]?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let issue = issue, issue.numComments > 0 {
            fetchCommentData(for: issue)
        }
    }

    func fetchCommentData(for issue: Issue) {
        Comment.fetch(for: issue.number) { [weak self] comments in
            self?.comments = comments
            self?.tableView.reloadData()
        }
    }

    // UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (issue?.body != nil) ? 1 : 0
        case 1:
            return comments?.count ?? 0
        default:
            return 0
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let comments = comments else {
            return 1
        }

        return comments.count > 0 ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let issue = issue,
              let cell = tableView.dequeueReusableCell(withIdentifier: "Comment", for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }

        switch indexPath.section {
        case 0:
            cell.header.text = "\(issue.user.login) commented on \(issue.openedDate.formatted())"
            cell.body.text = issue.body
        case 1:
            guard let comments = comments else {
                return UITableViewCell()
            }

            let comment = comments[indexPath.row]
            cell.header.text = "\(comment.user.login) commented on \(comment.date.formatted())"
            cell.body.text = comment.body
        default:
            return UITableViewCell()
        }

        return cell
    }

}
