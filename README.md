# GitIssues
3-hour project to show issues and comments on a GitHub repo.

### The assignment
* present all the "issues' for the public Stevia repo: https://github.com/freshOS/Stevia/issues
* allow user to select an issue and present all the comments from that selected issue
* Github's REST documentation for "issues" is here: https://docs.github.com/en/rest/reference/issues#list-repository-issues

### What I prioritized

* Basic MVP functionality without bugs
    - Page 1 of all issues (both open and closed) load in the background with no impact to the UI thread]
    - Issue rows can be selected, displaying a detail view with all comments for that issue
* A UI that should feel somewhat familiar to users of GitHub Issues on the browser
    - The body of the issue itself is presented as a "comment" at the top of the detail view, before all other comments loaded from the `comments_url`
* Concise, legible, clean code
* Fast iteration
* A functional dynamic layout that doesn't truncate any text
* Proper text formatting
* Pull-to-refresh on all views

### What could be improved with more time

* Architectural "finesse" (separate view models and data sources, moving some stuff out of the VCs) - I was more focused on getting the app done fast
* Error handling: it's currently just print statements, and I don't use `Result` at all. An error looks the same as an empty response.
* Differentiating between "closed" and "merged" issues
* Adding images such as avatars, icons, etc.
* Unit tests
* Avoiding extraneous network fetches by using a data store such as Core Data for larger datasets
* Use of more modern SDK features like async/await and SwiftUI or DiffableDataSource (I'm still fastest at old-fashioned UIKit)

### Where I stopped

I was in the process of getting pagination working; as of now, the `main` branch only returns the first 30 issues in the repo, and only the first 30 comments per issue. The issue I was having with this API is that it doesn't give you a total issue count in the response, so it makes it a bit trickier to get it right in the last ~20 minutes before time expired.

I put my work in progress on pagination in a separate `pagination` feature branch. It's only implemented on the `IssuesViewController` for now, not the `CommentsViewController`. I believe I just had to get the row count calculation correct so it would refetch the next page. I would have preferred to fix the bug, clean up the code more, and move some of the logic out of the VC and data models, before submitting this as a PR.