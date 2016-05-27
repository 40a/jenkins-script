if [ -f '.ruby-version' ]; then
  rbenv install -s `cat .ruby-version`
fi
bundle install --path vendor/bundle
