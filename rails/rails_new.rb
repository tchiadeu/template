# Gemfile
gem 'devise'
gem 'devise-i18n'
gem 'rubocop-rails', require: false
gem 'html_attrs'

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'dotenv-rails'
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

# General Config
general_config = <<~RUBY
  config.paths['app/views'].unshift(Rails.root.join('app/views/controllers'))
  config.autoload_paths << Rails.root.join("app", "views", "components")
  config.view_component.preview_paths << Rails.root.join("app", "views", "components")

  config.autoload_paths << Rails.root.join("app", "decorators")
  config.autoload_paths << Rails.root.join("app", "services")
RUBY

run 'mkdir app/services'
run 'mkdir app/decorators'
run 'touch .env'

# After bundle
after_bundle do
  git :init
  git add: '.'
  git commit: "-m 'Rails new / Initial Commit'"
  environment generators
  environment general_config
  rails_command "app:template LOCATION='https://railsbytes.com/script/zJosO5'"
end
