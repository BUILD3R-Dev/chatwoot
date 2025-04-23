module MyhelpchatBranding
  class Engine < ::Rails::Engine
    isolate_namespace MyhelpchatBranding

    initializer 'myhelpchat_branding.override' do |app|
      # Add overrides here
      # Example for overriding views:
      app.paths['app/views'] << "#{config.root}/app/views"
    end
  end
end
