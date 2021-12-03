//
//  Comments.swift
//  GitIssues
//
//  Created by John Penning on 12/3/21.
//

import Foundation

struct Comment: Codable {
    let url: String
    let user: User
    let date: Date
    let body: String?

    private enum CodingKeys: String, CodingKey {
        case url, user, body
        case date = "created_at"
    }

    static func fetch(for issue: Int) -> [Comment]? {
        let commentsApiUrl = URL(string: "https://api.github.com/repos/freshOS/Stevia/\(issue)/comments")!
        do {
            let data = try Data(contentsOf: commentsApiUrl)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let comments = try decoder.decode([Comment].self, from: data)
            return comments
        } catch {
            print("error fetching comments: \(error)")
            return nil
        }
    }
}
