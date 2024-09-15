# Gemfile
is_devise_needed = yes?('Install devise for the users?')
if is_devise_needed
  not_english_app = no?('The app will be for english users only?')
  devise_model_name = ask('What will be the model name for devise?')
end

gem 'devise' if is_devise_needed
gem 'devise-i18n' if is_devise_needed && not_english_app
gem 'tailwind_merge'
gem 'html_attrs'
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
  config.autoload_paths << Rails.root.join("app", "decorators")
  config.autoload_paths << Rails.root.join("app", "services")
RUBY

run 'mkdir app/services'
run 'mkdir app/decorators'
run 'touch .env'

# After bundle
after_bundle do
  rails_command 'generate rspec:install'
  if is_devise_needed
    rails_command 'generate devise:install'
    rails_command "generate devise #{devise_model_name}"
    run 'sudo service postgresql start'
    rails_command 'db:create'
    rails_command 'db:migrate'
    rails_command 'generate devise:views'
  end
  rails_command 'generate rspec:install'
  run 'mkdir spec/factories' unless is_devise_needed
  environment generators
  environment general_config
  rails_command "app:template LOCATION='https://railsbytes.com/script/zJosO5'"
  git :init
  git add: '.'
  git commit: "-m 'Rails new / Initial Commit'"
end
