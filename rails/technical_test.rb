# Gemfile

say '👋 Welcome to the user builder template'
is_devise_needed = yes?('Install devise for the users?')
devise_model_name = ask('What will be the model name for devise?') if is_devise_needed

if is_devise_needed
  gem 'devise'
  say_status :info, '✅ Devise gem added'
end

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'terminal-notifier-guard'
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
  environment generators
end
