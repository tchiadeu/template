# Gemfile
inject_into_file "Gemfile", before: "group :development, :test do" do
  <<~RUBY
    gem "devise"
    gem 'rubocop-rails', require: false
    gem "html_attrs"
    gem 'devise-i18n'
    gem "dry-initializer", "~> 3.1"
  RUBY
end

inject_into_file "Gemfile", after: "group :development, :test do" do
  <<~RUBY
    gem "rspec-rails"
    gem 'guard-rspec', require: false
    gem 'pry-rails'
    gem 'pry-byebug'
    gem "factory_bot_rails"
    gem "faker"
    gem "dotenv-rails"
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
RUBY

environment general_config


# After bundle
after_bundle do
  rails app:template LOCATION="https://railsbytes.com/script/zJosO5"
end
