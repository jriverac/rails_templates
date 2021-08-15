run 'pgrep spring | xargs kill -9'

gemfile_content = <<-RUBY
source 'https://rubygems.org'
ruby "2.5.3"
gem 'bootsnap', require: false
gem 'jbuilder', '~> 2.0'
gem 'pg', '~> 0.21'
gem 'puma'
gem 'rails', "6.0.0"
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

file '.ruby-version', '2.5.3'

file 'Procfile', <<-YAML
web: bundle exec puma -C config/puma.rb
YAML

markdown_file_content = <<-MARKDOWN
Rails app made with a custom template from railstemplates.net
Please read more on how to setup your app and using your custom features at www.railstemplates.net/documentation
MARKDOWN
file 'README.md', markdown_file_content, force: true

environment 'config.generators do |generate|
  generate.assets false
  generate.helper false
  generate.test_framework  :test_unit, fixture: false
end'

gsub_file('config/environments/development.rb', /config.assets.debug.*/, 'config.assets.debug = false')

run 'rm -rf app/assets/stylesheets'
run 'svn export https://github.com/davidmetta/rails_templates_assets/trunk/stylesheets'
run 'mv stylesheets app/assets'

run 'rm app/assets/javascripts/application.js'
file 'app/assets/javascripts/application.js', <<-JS
//= require rails-ujs
//= require jquery
//= require_tree .
JS

run 'rm app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.erb', <<-HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <%= csrf_meta_tags %>
    <%= action_cable_meta_tag %>
    <title><%= meta_title? meta_title : 'TODO' %></title>
    <meta name="description" content="<%= meta_description? meta_description : 'TODO' %>">
    <link rel="icon" type="image/png" href="<%= meta_image? : meta_image : 'TODO' %>">
    <!-- Facebook Open Graph data -->
    <meta property="og:title" content="<%= meta_title? meta_title : 'TODO' %>" />
    <meta property="og:type" content="website" />
    <meta property="og:url" content="<%= request.original_url %>" />
    <meta property="og:image" content="<%= meta_image? : meta_image : 'TODO' %>" />
    <meta property="og:description" content="<%= meta_description? meta_description : 'TODO' %>" />
    <meta property="og:site_name" content="<%= meta_title? meta_title : 'TODO' %>" />
    <%= stylesheet_link_tag 'application', media: 'all' %>
    <%#= stylesheet_pack_tag 'application', media: 'all' %> <!-- Uncomment if you import CSS in app/javascript/packs/application.js -->
  </head>
  <body>
    <%= yield %>
    <%= javascript_include_tag 'application' %>
    <%= javascript_pack_tag 'application' %>
  </body>
</html>
HTML

gsub_file('config/environments/production.rb', /config.assets.js_compressor.*/, 'config.assets.js_compressor = Uglifier.new(harmony: true)')

environment 'config.action_mailer.default_url_options = { host: "http://localhost:3000" }', env: 'development'
environment 'config.action_mailer.default_url_options = { host: "http://TODO_PUT_YOUR_DOMAIN_HERE" }', env: 'production'

" - Wendy"

after_bundle do

rails_command 'db:drop db:create db:migrate'

run 'yarn add popper.js jquery tippy.js'
inject_into_file 'config/webpack/environment.js', before: 'module.exports' do
<<-JS
const webpack = require('webpack')
// Preventing Babel from transpiling NodeModules packages
environment.loaders.delete('nodeModules');
// Bootstrap 4 has a dependency over jQuery & Popper.js:
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
)
JS
end

generate(:controller, 'pages', 'home', '--skip-routes', '--no-test-framework')
route "root to: 'pages#home'"

rails_command 'db:migrate'

gitignore_content = <<-TXT
.bundle
log/*.log
tmp/**/*
tmp/*
!log/.keep
!tmp/.keep
*.swp
.DS_Store
public/assets
public/packs
public/packs-test
node_modules
yarn-error.log
.byebug_history
.env*
TXT
run 'rm .gitignore'
file '.gitignore', gitignore_content

run 'touch .env'

git :init
git add: '.'
git commit: "-m 'initial commit'"

end

