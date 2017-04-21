# Whenever
#
# Configure how jobs are run
set :output, '/apps/wegoaudit/shared/log/schedule.log'

job_type :rake,
  "cd :path && ./bin/rake :task --silent :output"

job_type :runner,
  "cd :path && ./bin/rails runner ':task' :output"

#
#
# More info at: http://github.com/javan/whenever
#
every 5.minutes do
  runner 'QueueOrganizationBuildingsService.execute'
end

every 1.day, :at => '12:01 am' do
  runner "DeleteExpiredAuditsService.execute"
end
