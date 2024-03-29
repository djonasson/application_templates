gem "execjs"
gem "therubyracer"

# Templating engine and CSS framework
gem "haml-rails", :group => :development
gem "hpricot", :group => :development
gem "ruby_parser", :group => :development

gem "nifty-generators", :group => :development
gem "mocha"

# Form builder
gem "simple_form"

# authentication and authorization
gem "devise"
gem "cancan"

# rspec, factory girl, capybara, etc. for testing
gem "rails3-generators", :group => [ :development ]
gem "rspec-rails", :group => [ :development, :test ]
gem "factory_girl_rails", :group => [ :development, :test ]
gem "rcov", :group => [ :development, :test ]
gem "capybara", :group => :test
gem "ffaker", :group => :test
gem 'spork', '~> 0.9.0.rc', :group => [:development, :test]
gem 'guard-rspec', :group => [:development, :test]
gem 'guard-spork', :group => [:development, :test]
gem 'launchy', :group => [:development, :test]
gem 'rspec_multi_matchers', :group => [:development, :test]
gem 'random_data', :group => [:development, :test]

# Back-office
gem "activeadmin"

# Attachments
gem "paperclip"

# Pagination
gem "kaminari"


run 'bundle install'

run "bundle exec rake db:create", :env => :development
run "bundle exec rake db:create", :env => :test

generate 'nifty:layout --haml'
remove_file 'app/views/layouts/application.html.erb' # use nifty layout instead
generate 'simple_form:install'
generate 'nifty:config'
#remove_file 'public/javascripts/rails.js' # jquery-rails replaces this
generate 'rspec:install'
inject_into_file 'spec/spec_helper.rb', "\nrequire 'factory_girl'", :after => "require 'rspec/rails'"
inject_into_file 'config/application.rb', :after => "config.filter_parameters += [:password]" do
  <<-eos
    # Customize generators
    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
      g.test_framework :rspec
      g.stylesheets false
      g.form_builder :simple_form
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end
  eos
end
run "echo '--format documentation' >> .rspec"

generate "devise:install"
generate "active_admin:install User"
generate "devise:views users"

run "bundle exec rake db:migrate db:test:prepare"

generate "cancan:ability"
generate "active_admin:resource User"

generate "controller home index"
route 'root :to => "home#index"'

# clean up rails defaults
remove_file 'public/index.html'
remove_file 'rm public/images/rails.png'
#run 'cp config/database.yml config/database.example'
#run "echo 'config/database.yml' >> .gitignore"

say <<-eos
  ============================================================================
  Your new Rails application is ready to go.

  Don't forget to scroll up for important messages from installed generators.
eos
