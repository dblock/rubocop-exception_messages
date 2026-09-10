# AGENTS.md

Instructions for AI agents working in this repository.

* Read [CONTRIBUTING.md](CONTRIBUTING.md) before making changes and follow its workflow (topic branch, tests, changelog, etc.).
* A CHANGELOG.md entry is required for every pull request and must include a link to the PR number, e.g. `[#123](https://github.com/dblock/rubocop-exception_messages/pull/123)`. Figure out what the next PR number will be (e.g. from the latest open issue/PR number on GitHub) and use it up front, rather than opening the PR first and amending the CHANGELOG afterward.
* README examples use the `raise Class, "message"` form for brevity; don't repeat the `raise Class.new("message")`, `fail`, or `super("message")` forms in every example. All message-style cops recognize these equivalent forms, so document this once rather than in each cop's section. Show multiple forms only where the choice between them is what the cop itself checks (e.g. `ExceptionMessages/RequireMessage`).
* New cops must be `Enabled: true` by default in `config/default.yml`, matching every other cop in this repo. Before opening a PR, check `config/default.yml` for `Enabled: false` and fix any cop found disabled.
