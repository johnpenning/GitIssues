//
//  Issues.swift
//  GitIssues
//
//  Created by John Penning on 12/3/21.
//

import Foundation

struct Issue: Codable {
    let url: String
    let number: Int
    let title: String
    let numComments: Int
    let commentsUrl: String
    let user: User
    let state: State
    let openedDate: Date
    let updatedDate: Date
    let closedDate: Date?

    private enum CodingKeys: String, CodingKey {
        case url, number, title, user, state
        case numComments = "comments"
        case commentsUrl = "comments_url"
        case openedDate = "created_at"
        case updatedDate = "updated_at"
        case closedDate = "closed_at"
    }

    static func fetch() -> [Issue]? {
        let issuesApiUrl = URL(string: "https://api.github.com/repos/freshOS/Stevia/issues?state=all&sort=updated")!
        do {
            let data = try Data(contentsOf: issuesApiUrl)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let issues = try decoder.decode([Issue].self, from: data)
            return issues
        } catch {
            print("error: \(error)")
            return nil
        }
    }
}

struct User: Codable {
    let login: String
}

enum State: String, Codable {
    case open
    case closed
}
