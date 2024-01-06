# Slkecho

Slkecho is a CLI tool to post message to Slack like echo command.

## Installation

```
gem install slkecho
```

## Usage

```
slkecho -c <channel> -s <subject> -m <mention> message
```

### Options

#### -c, --channel <channel> (required)

Specify channel to post message. Channel name (starts `#`) or channel id (starts `C`).

#### -s, --subject <subject> (optional)

Specify subject to post message.

#### -m, --mention <mention> (optional)

Specify mention to post message. user email or user id (starts `U`).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/okonomi/slkecho.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
