require 'net/http'
require 'uri'
require 'json'
require 'optparse'

# コマンドライン引数を解析する
options = {}
opts = OptionParser.new do |opts|
  opts.banner = "Usage: echo2slack.rb [options] or echo | echo2slack.rb [options]"

  opts.on("-c", "--channel CHANNEL", "Slack channel to post the message") do |c|
    options[:channel] = c
  end
end
opts.parse!

# メッセージを標準入力から取得
options[:message] = ARGV.empty? ? STDIN.read.chomp : ARGV.first

# チャンネル名のバリデーション
if options[:channel].nil? || options[:message].empty?
  puts "Both message and channel are required."
  puts opts
  exit 1
end

# Slack APIへのリクエストを構築
uri = URI("https://slack.com/api/chat.postMessage")
request = Net::HTTP::Post.new(uri)
request.content_type = "application/json; charset=utf-8"
request["Authorization"] = "Bearer #{ENV['SLACK_API_TOKEN']}" # 環境変数からトークンを取得
request.body = {
  channel: options[:channel],
  text: options[:message]
}.to_json

# HTTPリクエストを送信し、エラーをハンドルする
begin
  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  # レスポンスのチェック
  result = JSON.parse(response.body)
  if response.is_a?(Net::HTTPSuccess) && result["ok"]
    puts "Message sent successfully."
  else
    puts "Error sending message: #{result['error']}"
    exit 1
  end
rescue => e
  puts "HTTP Request failed: #{e.message}"
  exit 1
end
