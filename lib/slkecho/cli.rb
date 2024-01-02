# frozen_string_literal: true

require "net/http"
require "uri"
require "json"
require "optparse"

module Slkecho
  class CLI
    Options = Struct.new(:channel, :subject, :message, keyword_init: true)

    def self.parse_options(argv) # rubocop:disable Metrics/MethodLength
      # コマンドライン引数を解析する
      options = Slkecho::CLI::Options.new
      opts = OptionParser.new do |o|
        o.banner = "Usage: echo2slack.rb [options] or echo | echo2slack.rb [options]"

        o.on("-c", "--channel CHANNEL", "Slack channel to post the message") do |c|
          options.channel = c
        end
        o.on("-s", "--subject SUBJECT", "Subject of message") do |s|
          options.subject = s
        end
      end
      argv = opts.parse(argv)

      options.message = argv.first unless argv.empty?

      options
    end

    def self.validate_options(options)
      # チャンネル名のバリデーション
      raise Slkecho::InvalidOptionError, "channel is required." if options[:channel].nil?
      raise Slkecho::InvalidOptionError, "channel must start with #." unless options[:channel].start_with?("#")

      # メッセージのバリデーション
      raise Slkecho::InvalidOptionError, "message is missing." if options[:message].nil?

      true
    end

    def self.start(argv) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      options = parse_options(argv)
      validate_options(options)

      uri = URI.parse("https://slack.com/api/chat.postMessage")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      headers = {
        "Content-Type" => "application/json; charset=utf-8",
        "Authorization" => "Bearer #{ENV["SLACK_API_TOKEN"]}" # 環境変数からトークンを取得
      }
      body = {
        "channel" => options[:channel],
        "blocks" => []
      }

      unless options[:subject].nil?
        body["blocks"] << {
          "type" => "header",
          "text" => {
            "type" => "plain_text",
            "text" => options[:subject],
            "emoji" => true
          }
        }
      end

      body["blocks"] << {
        "type" => "context",
        "elements" => [
          {
            "type" => "mrkdwn",
            "text" => options[:message]
          }
        ]
      }

      # HTTPリクエストを送信し、エラーをハンドルする
      begin
        response = http.post(uri.path, body.to_json, headers)

        # レスポンスのチェック
        result = JSON.parse(response.body)
        if response.is_a?(Net::HTTPSuccess) && result["ok"]
          puts "Message sent successfully."
        else
          puts "Error sending message: #{result["error"]}"
          exit 1
        end
      rescue StandardError => e
        puts "HTTP Request failed: #{e.message}"
        exit 1
      end
    end
  end
end
