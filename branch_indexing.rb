REPOSITORY_URL = ENV['REPOSITORY_URL']
FOLDER_NAME = File.dirname(ENV['JOB_NAME'])
JOBS_DIR = "#{ENV['JENKINS_HOME']}/jobs/#{FOLDER_NAME}/jobs"

def job_name(branch_name)
  branch_name.gsub('/', '_')
end

def branches
  @branches ||= `git ls-remote #{REPOSITORY_URL} "refs/*"`.each_line
                    .map { |line| line.split(/\s+/)[1] }
                    .select { |ref| ref.include?('/heads/') }
                    .map { |ref| ref.gsub('refs/heads/', '') }
end

def branch_jobs
  @branch_jobs ||= branches.map { |branch| branch.gsub('/', '_') }
end

def execJenkinsCli(command)
  `java -jar jenkins-cli.jar -s http://localhost:8080/ -i /var/lib/jenkins/.ssh/id_rsa #{command}`
end

#
# jenkins-cli.jar のダウンロード
#
`wget 'http://localhost:8080/jnlpJars/jenkins-cli.jar'` unless File.exists? 'jenkins-cli.jar'

#
# ジョブテンプレートの取得
#
`rm -rf jenkins-job-templates`
`git clone https://github.com/wiro34/jenkins-job-templates.git`

#
# 不要なブランチジョブの削除
#
jobs = `ls "#{JOBS_DIR}" | grep "\\(master\\|develop\\)"`.each_line.map(&:chomp).to_a
# (jobs - branch_jobs).each do |job|
jobs.each do |job|
 puts "Removing job: #{job}"
 execJenkinsCli "delete-job \"#{FOLDER_NAME}/#{job}\""
end

#
# 新しいブランチジョブの作成
#
branches.each do |branch|
  name = job_name branch
  job_dir = "#{JOBS_DIR}/#{name}"
  next if Dir.exists? job_dir

  puts "Creating job for '#{branch}'"
  `cp -r jenkins-job-templates/branch-job "#{job_dir}"`
  `sed -ie 's/${REPOSITORY_URL}/#{REPOSITORY_URL.gsub('/', '\\/')}/' "#{job_dir}"/config.xml`
  `sed -ie 's/${BRANCH_NAME}/#{branch.gsub('/', '\\/')}/' "#{job_dir}"/config.xml`
  `sed -ie 's/${DISPLAY_NAME}/#{branch.gsub('/', '\\/')}/' "#{job_dir}"/config.xml`
end

execJenkinsCli 'reload-configuration'
