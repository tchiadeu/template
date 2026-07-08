# Gemfile
say '👋 Welcome to the user builder template'
gem 'tailwind_merge'
gem 'view_component-contrib'

gem_group :development, :test do
  gem 'rspec-rails'
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
  config.autoload_paths << Rails.root.join("app", "decorators", "concerns")
RUBY

run 'mkdir -p app/decorators/concerns'

# After bundle
after_bundle do
  generate('rspec:install')
  run 'mkdir spec/factories'
  run 'rm -rf test'
  run 'corepack enable'
  run 'touch .yarnrc'
  run 'echo "version=4.5.3" > .yarnrc'
  run 'touch yarn.lock'
  run 'yarn init -y'
  run 'yarn add corepack'
  run 'bundle add vite_rails'
  run 'bundle exec vite install'
  environment generators
  environment general_config
  rails_command "app:template LOCATION='https://railsbytes.com/script/zJosO5'"
  git :init
  git add: '.'
  git commit: "-m 'Rails new / Initial Commit'"
end
