# frozen_string_literal: true

require "json"
require "launchy"
require "uri"
require "xdg"

require_relative "../http"

module Slkecho
  module Commands
    class ConfigureAuthentication
      def execute
        puts "configure slack api authentification"

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
        print "Enter your client ID: "
        client_id = $stdin.gets.chomp

        print "Enter your client secret: "
        client_secret = $stdin.gets.chomp

        [client_id, client_secret]
      end

      def build_authorize_url(client_id)
        authorize_url = URI("https://slack.com/oauth/v2/authorize")
        authorize_url.query = URI.encode_www_form({
                                                    user_scope: "users.profile:read",
                                                    redirect_uri: "https://okonomi.github.io/slkecho/callback.html",
                                                    client_id: client_id
                                                  })

        authorize_url
      end

      def exchange_code_for_access_token(code, client_id, client_secret)
        response = Slkecho::HTTP.post("https://slack.com/api/oauth.v2.access", body: {
                                        code: code,
                                        client_id: client_id,
                                        client_secret: client_secret,
                                        redirect_uri: "https://okonomi.github.io/slkecho/callback.html"
                                      })
        JSON.parse(response.body)
      end

      def save_token_info(token_info)
        xdg_config = XDG::Config.new
        config_dir = xdg_config.home.join("slkecho")
        config_dir.mkpath
        File.write(
          config_dir.join("token.json"),
          JSON.pretty_generate(
            token_info.slice("app_id", "authed_user", "team")
          )
        )
      end
    end
  end
end
