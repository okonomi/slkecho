# frozen_string_literal: true

require "launchy"
require "uri"

require_relative "../http"
require_relative "../config"

module Slkecho
  class Command
    class ConfigureUserToken
      def execute # rubocop:disable Metrics/MethodLength
        puts "Slkecho configuration"
        client_id, client_secret = gets_oauth2_credentials

        puts "Open the authorize URL in your browser..."
        Launchy.open(build_authorize_url(client_id))

        puts "Please enter the code from the URL:"
        print "code: "
        code = $stdin.gets.chomp

        puts "Exchange the code for an access token..."
        token_info = exchange_code_for_access_token(code, client_id, client_secret)

        puts "Save token_info to a file..."
        save_token_info(token_info)
      end

      private

      def gets_oauth2_credentials
        print "Enter your Slack App Client ID: "
        client_id = $stdin.gets.chomp

        print "Enter your Slack App Client Secret: "
        client_secret = $stdin.gets.chomp

        [client_id, client_secret]
      end

      def build_authorize_url(client_id)
        query_params = {
          user_scope: "users.profile:read",
          redirect_uri: "https://okonomi.github.io/slkecho/callback.html",
          client_id: client_id
        }
        URI::HTTPS.build(
          host: "slack.com",
          path: "/oauth/v2/authorize",
          query: URI.encode_www_form(query_params)
        )
      end

      def exchange_code_for_access_token(code, client_id, client_secret)
        body = {
          code: code,
          client_id: client_id,
          client_secret: client_secret,
          redirect_uri: "https://okonomi.github.io/slkecho/callback.html"
        }
        response = Slkecho::HTTP.post("https://slack.com/api/oauth.v2.access", body: URI.encode_www_form(body))
        JSON.parse(response.body)
      end

      def save_token_info(token_info)
        Slkecho::Config.save(
          token_info.slice("app_id", "authed_user", "team")
        )
      end
    end
  end
end
