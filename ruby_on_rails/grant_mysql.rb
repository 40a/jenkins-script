require 'yaml'

config = YAML.load_file('config/database.yml')[ENV['RAILS_ENV']]
`mysql -u root -e "grant all on #{config['database']}.* to #{config['username']}@'localhost' identified by '#{config['password']}'" -h #{config['host']}`