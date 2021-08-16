gemfile_content = <<~RUBY
  source 'https://rubygems.org'
  ruby "2.7.4"
  gem 'bootsnap', require: false
  gem 'jbuilder', '~> 2.0'
  gem 'pg', '~> 0.21'
  gem 'puma'
  gem 'rails', "~> 6.1.3.1"
  gem 'redis', '~> 3.3', '>= 3.3.1'
  gem 'devise'
  gem 'autoprefixer-rails'
  gem 'sassc-rails'
  gem 'simple_form'
  gem 'uglifier'
  gem 'webpacker'
  group :development do
    gem 'web-console', '>= 3.3.0'
    gem 'rack-mini-profiler'
    gem 'bullet'
  end
  group :development, :test do
    gem 'dotenv-rails'
    gem 'pry-byebug'
    gem 'pry-rails'
    gem 'listen', '~> 3.0.5'
    gem 'spring'
    gem 'spring-watcher-listen', '~> 2.0.0'
  end
RUBY

run 'rm Gemfile'
file 'Gemfile', gemfile_content

file 'Procfile', <<-YAML
web: bundle exec puma -C config/puma.rb
YAML

readme_content = <<-MARKDOWN
# ReadMe
This is how it starts.
file 'README.md', readme_content, force: true