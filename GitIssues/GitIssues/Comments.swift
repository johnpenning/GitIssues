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

    static func fetch(for issue: Int, completion: @escaping ([Comment]?) -> Void) {
        let commentsApiUrl = URL(string: "https://api.github.com/repos/freshOS/Stevia/issues/\(issue)/comments")!

        URLSession.shared.dataTask(with: commentsApiUrl) { data, response, error in
            var comments: [Comment]?
            defer {
                DispatchQueue.main.async {
                    completion(comments)
                }
            }

            if let error = error {
                print("error fetching comments: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            do {
                comments = try decoder.decode([Comment].self, from: data)
            } catch {
                print("error decoding comments: \(error.localizedDescription)")
            }
        }.resume()
    }
}
