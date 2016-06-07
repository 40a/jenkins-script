def version = '1.0'

def deploy(envName) {
  env.RAILS_ENV = envName
  input 'OK?'
}

return this;
