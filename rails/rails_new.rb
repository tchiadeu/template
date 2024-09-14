# Gemfile
inject_into_file "Gemfile", before: "group :development, :test do" do
  <<~RUBY
    gem 'devise'
    gem 'devise-i18n'
    gem 'rubocop-rails', require: false
    gem 'html_attrs'
  RUBY
end


# Generators
generators = <<~RUBY
  config.generators do |generate|
    generate.assets false
    generate.helper false
    generate.test_framework :rspec,
      fixture_replacement: :factory_bot,
      helper_specs: false,
      view_specs: false,
      routing_specs: false,
    generate.fixture_replacement :factory_bot, dir: 'spec/factories'
  end
RUBY

environment generators

# General Config
general_config = <<~RUBY
  config.paths['app/views'].unshift(Rails.root.join('app/views/controllers'))
  config.autoload_paths << Rails.root.join("app", "views", "components")
  config.view_component.preview_paths << Rails.root.join("app", "views", "components")

  config.autoload_paths << Rails.root.join("app", "decorators")
  config.autoload_paths << Rails.root.join("app", "services")
RUBY

environment general_config

run "mkdir app/services"
run "mkdir app/decorators"
run "touch .env"

# After bundle
after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Rails new / Initial commit' }
  rails_command "app:template LOCATION='https://railsbytes.com/script/zJosO5'"
end
