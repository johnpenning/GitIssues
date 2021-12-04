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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (issue?.body != nil) ? 1 : 0
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let issue = issue,
              let cell = tableView.dequeueReusableCell(withIdentifier: "Comment", for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }

        cell.header.text = "issue body"
        cell.body.text = issue.body

        return cell
    }

}
