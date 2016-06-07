def repo = 'https://github.com/wiro34/jenkins-script.git'
def bootstrap, environment, build, test, deploy, qa, releaseJudge

fileLoader.withGit(repo, 'master', null, '') {
    bootstrap = fileLoader.load('templates/ruby_on_rails/bootstrap');
    environment = fileLoader.load('templates/ruby_on_rails/environment');
    build = fileLoader.load('templates/ruby_on_rails/build');
    test = fileLoader.load('templates/ruby_on_rails/test');
    deploy = fileLoader.load('templates/ruby_on_rails/deploy');
    qa = fileLoader.load('templates/ruby_on_rails/qa');
    // releaseJudge = fileLoader.load('templates/ruby_on_rails/releaseJudge');
}

stage 'Build'
node {
    bootstrap.installRuby()
    bootstrap.bundleInstall()
    build.precompileAssets()
}

stage 'Test'
node {
    test.runTests()
}

stage 'Staging Deploy'
node {
    deploy.deploy('staging')
}

stage 'QA'
node {
    qa.qa()
}

stage 'Release Judgement'
node {
    input 'OK?'
}

stage 'Production Deploy'
node {
    deploy.deploy('production')
}
