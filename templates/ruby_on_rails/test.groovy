def version = '1.0'

def runTests() {
  env.RAILS_ENV = 'test'
  // ruby -e "$(curl -fsSL https://raw.githubusercontent.com/wiro34/jenkins-script/master/ruby_on_rails/grant_mysql.rb)"
  sh 'bundle exec rake db:create'
  sh 'bundle exec rake db:schema:load'
  sh 'bundle exec rake'
}

return this;
