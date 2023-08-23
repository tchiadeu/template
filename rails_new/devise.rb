# Gemfile
inject_into_file "Gemfile", before: "group : development, :test do" do
  <<~RUBY
    gem "font-awesome-sass", "~> 6.1"
  RUBY
end

inject_into_file "Gemfile", after: 'gem "debug", platforms: %i[mri mingw x64_mingw]' do
  "\n gem \"dotenv-rails\""
end

gsub_file("Gemfile", '# gem "sassc-rails"', 'gem "sassc-rails"')
