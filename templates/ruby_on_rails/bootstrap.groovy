def version = '1.0'

def installRuby() {
  sh "if [ -f '.ruby-version' ]; then rbenv install -s `cat .ruby-version`; fi"
}

def bundleInstall() {
  sh 'bundle install --path vendor/bundle'
}

return this;
