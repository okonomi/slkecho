<div align="center">
  <img src="assets/icon.png" width="128" height="128" alt="Slkecho icon">
</div>

# Slkecho

[![Gem Version](https://badge.fury.io/rb/slkecho.svg)](https://badge.fury.io/rb/slkecho)

Slkecho is a CLI tool to post message to Slack like echo command.

## Installation

Install it yourself as:

```
gem install slkecho
```

or run without installation:

```
gem exec slkecho
```

## Setup

Before using slkecho, you need to configure your Slack API token:

```
slkecho --configure
```

This will:
1. Prompt you to enter your Slack App Client ID and Client Secret
2. Open a browser for OAuth authorization
3. Save the access token to `~/.config/slkecho/token.json`

Once configured, you can use slkecho without the `--token` option.

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

#### --message-as-blocks (optional)

Post message as blocks.

See below: https://api.slack.com/methods/chat.postMessage#arg_blocks

#### --token <token> (optional)

Pass a token to authenticate with Slack.

#### --configure (optional)

Configure Slack API token via OAuth 2.0 authentication.
Saves token to `~/.config/slkecho/token.json` (or `$XDG_CONFIG_HOME/slkecho/token.json`).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/okonomi/slkecho.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
