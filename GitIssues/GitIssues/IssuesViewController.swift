//
//  IssuesViewController.swift
//  GitIssues
//
//  Created by John Penning on 12/3/21.
//

import UIKit

class IssuesViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let issues = Issue.fetch()

        print("issues: \(issues)")
    }


}

