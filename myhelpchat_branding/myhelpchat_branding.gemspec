require_relative "lib/myhelpchat_branding/version"

Gem::Specification.new do |spec|
  spec.name        = "myhelpchat_branding"
  spec.version     = MyhelpchatBranding::VERSION
  spec.authors     = ["BUILD3R-Dev"]
  spec.email       = ["dev@build3r.io"]
  spec.homepage    = "https://example.com"
  spec.summary     = "Branding engine for MyHelpChat."
  spec.description = "Rails engine to rebrand Chatwoot as MyHelpChat."

  # Remove or update allowed_push_host as needed
  # spec.metadata["allowed_push_host"] = "http://mygemserver.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://example.com"
  spec.metadata["changelog_uri"] = "https://example.com"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.8.7"
end
