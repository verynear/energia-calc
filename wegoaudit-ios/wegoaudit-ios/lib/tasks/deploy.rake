# Set of rake tasks for building and deploying beta versions of WegoAudit.
namespace :deploy do
  desc 'Build and push a new version of WegoAudit (Staging)'
  task :staging do
    ENV['MOTION_ENV'] = 'staging'
    Rake::Task['hockeyapp'].invoke
  end

  desc 'Build and push a new production version of WegoAudit'
  task :production do
    ENV['MOTION_ENV'] = 'production'
    Rake::Task['hockeyapp'].invoke
  end
end
