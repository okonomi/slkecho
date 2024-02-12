## [Unreleased]

- refactor: Use pattern matching
- chore: Add rubocop-rake

## [v2.1.1] - 2024-02-12

- chore: Add ruby-lsp gem
- refactor: Parse JSON with symbolize names
- refactor: Make request body with symbolize keys
- refactor: Make blocks with symbolize keys
- refactor: Extract http response checking
- test: Introduce saharspec gem

## [v2.1.0] - 2024-01-19

- feat: Add --message-as-blocks option
- fix: Require libraries
- style: Enable RuboCop new cops and fix offenses
- style: Add rubocop-performance and fix offenses

## [v2.0.1] - 2024-01-17

- feat: Add Dockerfile
- ci: Add release gem workflow
- ci: Add release container image workflow
- fix: Exclude unnecessary files from the .gem

## [v2.0.0] - 2024-01-12

- feat: Remove --subject option
- feat: Rename --mention option to --mention-by-email option
- feat: Rename errors
  - `Slkecho::SlackApiRequestError` to `Slkecho::SlackApiHttpError`
  - `Slkecho::SlackApiResponseErorr` to `Slkecho::SlackApiResultError`
- feat: Improve error message of Slack API request
- feat: Remove channel validation
- chore: Update options description

## [v1.4.0] - 2024-01-09

- feat: Add --icon-emoji option

## [v1.3.0] - 2024-01-08

- chore: Improved description of username option
- feat: Add --icon-url option
- refactor: Remove `Slkecho::Options` initialize method
- refactor: Summarize arguments of `Slkecho::SlackRequest::PostMessage#request` to params
- refactor: Summarize arguments of `Slkecho::SlackClient#post_message` to params

## [v1.2.1] - 2024-01-08

- fix: Not implemented to username specified

## [v1.2.0] - 2024-01-08

- feat: Add --username option

## [v1.1.0] - 2024-01-08

- test: reset SLACK_API_TOKEN env var
- feat: Message can be set from stdin

## [v1.0.1] - 2024-01-08

- fix: Delay validation of configuration
- fix: Error messages are now output to stderr

## [v1.0.0] - 2024-01-06

- docs: Update installation section
- feat: Improve error message
- style: Align line wrapping

## [v0.3.0] - 2024-01-06

- Allow channel id
- Allow user id
- Update README

## [v0.2.1] - 2024-01-06

- Fix error handling

## [v0.2.0] - 2024-01-06

- chore: add dotenv extension
- Add --mention option
- Improve error handling
- Command line options

## [v0.1.0] - 2024-01-03

- Initial release
