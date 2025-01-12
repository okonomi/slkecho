# frozen_string_literal: true

require "net/http"
require "uri"

module Slkecho
  class HTTP
    class << self
      def get(url, headers: nil)
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == "https"
        http.get(uri, headers)
      end

      def post(url, headers: nil, body: nil)
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == "https"
        http.post(uri, body, headers)
      end
    end
  end
end
