#!groovy

def project

def judge_project_type() {
  return 'ruby_on_rails'
}

stage 'Checkout SCM'
node {
  git branch: env.BRANCH, url: env.REPOSITORY_URL
  project = judge_project_type()
}

def pipeline = fileLoader.fromGit(project + '.jenkinsfile', 'https://github.com/wiro34/jenkins-script.git', 'master', null, '')
pipeline.start()
