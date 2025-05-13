# Gemfile
say '👋 Welcome to the user builder template'
is_devise_needed = yes?('Install devise for the users?')
if is_devise_needed
  not_english_app = no?('The app will be for english users only?')
  devise_model_name = ask('What will be the model name for devise?')
end

if is_devise_needed
  gem 'devise'
  say_status :info, '✅ Devise gem added'
  if not_english_app
    gem 'devise-i18n'
    say_status :info, '✅ Devise-I18n gem added'
  end
end
gem 'tailwind_merge'
gem 'view_component-contrib'

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'dotenv-rails'
end

gem_group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "database_cleaner-active_record"
end

# Generators
generators = <<~RUBY
  config.generators do |generate|
    generate.assets false
    generate.helper false
    generate.test_framework(
      :rspec,
      fixture_replacement: :factory_bot,
      helper_specs: false,
      view_specs: false,
      routing_specs: false,
    )
    generate.fixture_replacement :factory_bot, dir: 'spec/factories'
  end
RUBY

# General Config
general_config = <<~RUBY
  config.paths['app/views'].unshift(Rails.root.join('app/views/controllers'))
  config.autoload_paths << Rails.root.join("app", "views", "components")
  config.view_component.preview_paths << Rails.root.join("app", "views", "components")
  config.autoload_paths << Rails.root.join("app", "decorators", "concerns")
RUBY

run 'mkdir app/services'
run 'mkdir app/decorators'
run 'touch .env'

# After bundle
after_bundle do
  if is_devise_needed
    generate('devise:install')
    generate('devise', devise_model_name)
    rails_command 'db:create db:migrate'
    generate('devise:views')
  end
  generate('rspec:install')
  run 'bundle exec guard init rspec'
  run 'mkdir spec/factories' unless is_devise_needed
  run 'rm -rf test'
  run 'touch yarn.lock'
  run 'yarn init -y'
  run 'bundle add vite_rails'
  run 'bundle exec vite install'
  environment generators
  environment general_config
  rails_command "app:template LOCATION='https://railsbytes.com/script/zJosO5'"
  git :init
  git add: '.'
  git commit: "-m 'Rails new / Initial Commit'"
end
