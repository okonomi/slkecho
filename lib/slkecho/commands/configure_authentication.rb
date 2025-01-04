# frozen_string_literal: true

require "launchy"

module Slkecho
  module Commands
    class ConfigureAuthentication
      def execute
        puts "configure slack api authentification"

        client_id, client_secret = gets_oauth2_credentials

        puts "Open the authorize URL in your browser..."
        Launchy.open(build_authorize_url(client_id))
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
    end
  end
end
