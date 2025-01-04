# frozen_string_literal: true

module Slkecho
  module Commands
    class ConfigureAuthentication
      def execute
        puts "configure slack api authentification"

        client_id, client_secret = gets_oauth2_credentials
      end

      private

      def gets_oauth2_credentials
        print "Enter your client ID: "
        client_id = $stdin.gets.chomp

        print "Enter your client secret: "
        client_secret = $stdin.gets.chomp

        [client_id, client_secret]
      end
    end
  end
end
