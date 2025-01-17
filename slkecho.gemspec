# frozen_string_literal: true

require_relative "lib/slkecho/version"

Gem::Specification.new do |spec|
  spec.name = "slkecho"
  spec.version = Slkecho::VERSION
  spec.authors = ["okonomi"]
  spec.email = ["okonomi@oknm.jp"]

  spec.summary = "Post message to Slack like echo command."
  spec.description = "Post message to Slack like echo command."
  spec.homepage = "https://github.com/okonomi/slkecho"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/okonomi/slkecho"
  spec.metadata["changelog_uri"] = "https://github.com/okonomi/slkecho/blob/main/CHANGELOG.md"
  spec.metadata["github_repo"] = "https://github.com/okonomi/slkecho"

  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(
          *%w[bin/ test/ spec/ features/ .git .github .rspec .rubocop.yml .vscode appveyor Dockerfile Gemfile Rakefile]
        )
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel"
  spec.add_dependency "launchy"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
