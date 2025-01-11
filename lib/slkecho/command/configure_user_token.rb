# frozen_string_literal: true

module Slkecho
  class Command
    class ConfigureUserToken
      def execute
        puts "Slkecho configuration"
        client_id, client_secret = gets_oauth2_credentials
      end

      private

      def gets_oauth2_credentials
        print "Enter your Slack App Client ID: "
        client_id = $stdin.gets.chomp

        print "Enter your Slack App Client Secret: "
        client_secret = $stdin.gets.chomp

        [client_id, client_secret]
      end
    end
  end
end
