export RAILS_ENV=test
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/wiro34/jenkins-script/master/ruby_on_rails/grant_mysql.rb)"
bundle exec rake db:create
bundle exec rake db:schema:load
