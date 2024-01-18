# Slkecho

[![Gem Version](https://badge.fury.io/rb/slkecho.svg)](https://badge.fury.io/rb/slkecho)

Slkecho is a CLI tool to post message to Slack like echo command.

## Installation

Install it yourself as:

```
gem install slkecho
```

or add this line to your application's Gemfile:

```
source "https://rubygems.pkg.github.com/okonomi" do
  gem "slkecho"
end
```

More details: [Working with the RubyGems registry - GitHub Docs](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-rubygems-registry#installing-a-package)

## Usage

```
slkecho -c <channel> -m <mention> message
```

or message from stdin:

```
cat message.txt | slkecho -c <channel> -m <mention>
```

### Options

#### -c, --channel <channel> (required)

Slack channel to post message.

See below: https://api.slack.com/methods/chat.postMessage#arg_channel

#### -m, --mention-by-email <mention> (optional)

Search for the target member by email address and adds a mentions to the message.
Mention is only valid for members of the channel to which you are posting.

#### --username <username> (optional)

Set user name for message.

See below: https://api.slack.com/methods/chat.postMessage#arg_username

#### --icon-url <url> (optional)

Set user icon image for message by URL.

See below: https://api.slack.com/methods/chat.postMessage#arg_icon_url

#### --icon-emoji <emoji> (optional)

Set user image for message by emoji.

See below: https://api.slack.com/methods/chat.postMessage#arg_icon_emoji

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/okonomi/slkecho.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
