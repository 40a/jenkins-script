def version = '1.0'

def precompileAssets() {
  sh 'bundle exec rake assets:precompile'
}

return this;
