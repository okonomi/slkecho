# frozen_string_literal: true

require "net/http"
require "uri"

module Slkecho
  class HTTP
    class << self
      def get(uri, headers: nil)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == "https"
        http.get(uri, headers)
      end
    end
  end
end
