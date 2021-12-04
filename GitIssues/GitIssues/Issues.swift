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
    let body: String?

    private enum CodingKeys: String, CodingKey {
        case url, number, title, user, state, body
        case numComments = "comments"
        case commentsUrl = "comments_url"
        case openedDate = "created_at"
        case updatedDate = "updated_at"
        case closedDate = "closed_at"
    }

    static func fetch(page: Int, completion: @escaping ([Issue]?) -> Void) {
        let issuesApiUrl = URL(string: "https://api.github.com/repos/freshOS/Stevia/issues?state=all&sort=updated&page=\(page)")!

        URLSession.shared.dataTask(with: issuesApiUrl) { data, response, error in
            var issues: [Issue]?
            defer {
                DispatchQueue.main.async {
                    completion(issues)
                }
            }
            if let error = error {
                print("error fetching issues: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                issues = try decoder.decode([Issue].self, from: data)
            } catch {
                print("error decoding issues: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct User: Codable {
    let login: String
}

enum State: String, Codable {
    case open
    case closed
}
