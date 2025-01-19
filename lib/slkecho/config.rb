# frozen_string_literal: true

module Slkecho
  class Config
    class << self
      def config_dir
        Pathname.new(ENV["XDG_CONFIG_HOME"] || File.join(Dir.home, ".config"))
      end

      def config_path
        config_dir.join("slkecho/token.json")
      end

      def save(data)
        path = config_path
        path.dirname.mkpath
        File.write(path, JSON.pretty_generate(data))
      end

      def load
        path = config_path
        return nil unless path.exist?

        JSON.parse(path.read)
      end
    end
  end
end
