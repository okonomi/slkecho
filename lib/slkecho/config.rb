module Slkecho
  class Config
    def self.config_dir
      if ENV.key?("XDG_CONFIG_HOME")
        Pathname.new(ENV["XDG_CONFIG_HOME"])
      else
        Pathname.new(Dir.home).join(".config")
      end
    end

    def self.config_path
      config_dir.join("slkecho", "token.json")
    end

    def self.save(data)
      path = config_path
      path.dirname.mkpath
      File.write(path, JSON.pretty_generate(data))
    end

    def self.load
      path = config_path
      return nil unless path.exist?

      JSON.parse(path.read)
    end
  end
end
