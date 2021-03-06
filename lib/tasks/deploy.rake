
desc "deploy staging"
task :deploy_staging => [ 'deploy:set_staging_app', 'deploy:push', 
                          'deploy:off', 'deploy:migrate', 'deploy:restart', 
                          'deploy:on', 'deploy:tag']

desc "deploy production"
task :deploy_production => ['deploy:set_production_app', 'deploy:push', 
                            'deploy:off', 'deploy:migrate', 'deploy:restart', 
                            'deploy:on', 'deploy:tag']

desc "mirror production to staging"
task :deploy_production_to_staging => [ 'deploy:production_to_staging', 'deploy:mirror_production_db' ]

namespace :deploy do
  PRODUCTION_APP = 'pledgeproject'
  STAGING_APP = 'pledgedev'

  task :staging_migrations => [:set_staging_app, :push, :off, :migrate, :restart, :on, :tag]
  task :staging_rollback => [:set_staging_app, :off, :push_previous, :restart, :on]

  task :production_migrations => [:set_production_app, :push, :off, :migrate, :restart, :on, :tag]
  task :production_rollback => [:set_production_app, :off, :push_previous, :restart, :on]

  task :set_staging_app do
    APP = STAGING_APP
  end

  task :set_production_app do
  	APP = PRODUCTION_APP
  end

  task :production_to_staging do
    prefix = "#{PRODUCTION_APP}_release-"
    releases = `git tag`.split("\n").select { |t| t[0..prefix.length-1] == prefix }.sort
    current_prod_release = releases.last

    puts "######### Rolling staging back to production '#{current_prod_release}' ..."
  
    puts "######### Checking out '#{current_prod_release}' in a new branch on local git repo ..."
    puts `git checkout #{current_prod_release}`
    puts `git checkout -b prod`
      
    puts "######### Pushing '#{current_prod_release}' to Staging master ..."
    puts `git push git@heroku.com:#{STAGING_APP}.git +prod:master --force`
      
    puts "######### Deleting local branch..."
    puts `git checkout master`
    puts `git branch -d prod`

    puts "######### Staging is now running production code..."
  end

  task :mirror_production_db do
    puts '######### Pulling DB from production... Are you sure you want to overwrite the local database (y/n)?'
    puts `heroku db:pull --app #{PRODUCTION_APP}`

    puts '######### Pushing DB to staging... Are you sure you want to overwrite the staging database (y/n)?'
    puts `heroku db:push --app #{STAGING_APP}`
    puts '######### Production DB is now mirrored on local dev & staging.'
  end

  task :push do
    puts 'Deploying site to Heroku ...'
    puts `git push -f git@heroku.com:#{APP}.git`
  end
  
  task :restart do
    puts 'Restarting app servers ...'
    puts `heroku restart --app #{APP}`
  end
  
  task :tag do
    release_name = "#{APP}_release-#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
    puts "Tagging release as '#{release_name}'"
    puts `git tag -a #{release_name} -m 'Tagged release'`
    puts `git push --tags git@heroku.com:#{APP}.git`
  end
  
  task :migrate do
    puts 'Running database migrations ...'
    puts `heroku rake db:migrate --app #{APP}`
  end
  
  task :off do
    puts 'Putting the app into maintenance mode ...'
    puts `heroku maintenance:on --app #{APP}`
  end
  
  task :on do
    puts 'Taking the app out of maintenance mode ...'
    puts `heroku maintenance:off --app #{APP}`
  end
  
  task :push_previous do
    prefix = "#{APP}_release-"
    releases = `git tag`.split("\n").select { |t| t[0..prefix.length-1] == prefix }.sort
    current_release = releases.last
    previous_release = releases[-2] if releases.length >= 2
    if previous_release
      puts "Rolling back to '#{previous_release}' ..."
      
      puts "Checking out '#{previous_release}' in a new branch on local git repo ..."
      puts `git checkout #{previous_release}`
      puts `git checkout -b #{previous_release}`
      
      puts "Removing tagged version '#{previous_release}' (now transformed in branch) ..."
      puts `git tag -d #{previous_release}`
      puts `git push git@heroku.com:#{APP}.git :refs/tags/#{previous_release}`
      
      puts "Pushing '#{previous_release}' to Heroku master ..."
      puts `git push git@heroku.com:#{APP}.git +#{previous_release}:master --force`
      
      puts "Deleting rollbacked release '#{current_release}' ..."
      puts `git tag -d #{current_release}`
      puts `git push git@heroku.com:#{APP}.git :refs/tags/#{current_release}`
      
      puts "Retagging release '#{previous_release}' in case to repeat this process (other rollbacks)..."
      puts `git tag -a #{previous_release} -m 'Tagged release'`
      puts `git push --tags git@heroku.com:#{APP}.git`
      
      puts "Turning local repo checked out on master ..."
      puts `git checkout master`
      puts 'All done!'
    else
      puts "No release tags found - can't roll back!"
      puts releases
    end
  end
end


# 
# desc "deploy"
# task :deploy => ['deploy:push', 'deploy:restart', 'deploy:tag']
# 
# namespace :deploy do
#   desc "migrations"
#   task :migrations => [:push, :off, :migrate, :restart, :on, :tag]
#   
#   desc "rollback"
#   task :rollback => [:off, :push_previous, :restart, :on]
# 
#   desc "push"
#   task :push => :environment do
#     puts 'Deploying site to Heroku ...'
#     puts `git push heroku`
#   end
# 
#   desc "restart"
#   task :restart => :environment  do
#     puts 'Restarting app servers ...'
#     puts `heroku restart`
#   end
#   
#   desc "tag"
#   task :tag => :environment  do
#     release_name = "release-#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
#     puts "Tagging release as '#{release_name}'"
#     puts `git tag -a #{release_name} -m 'Tagged release'`
#     puts `git push --tags heroku`
#   end
# 
#   desc "migrate"
#   task :migrate => :environment  do
#     puts 'Running database migrations ...'
#     puts `heroku rake db:migrate`
#   end
# 
#   desc "off"
#   task :off => :environment  do
#     puts 'Putting the app into maintenance mode ...'
#     puts `heroku maintenance:on`
#   end
# 
#   desc "on"
#   task :on => :environment  do
#     puts 'Taking the app out of maintenance mode ...'
#     puts `heroku maintenance:off`
#   end
# 
#   desc "push_previous"
#   task :push_previous => :environment  do
#     releases = `git tag`.split("\n").select { |t| t[0..7] == 'release-' }.sort
#     current_release = releases.last
#     previous_release = releases[-2] if releases.length >= 2
#     if previous_release
#       puts "Rolling back to '#{previous_release}' ..."
#       
#       puts "Checking out '#{previous_release}' in a new branch on local git repo ..."
#       puts `git checkout #{previous_release}`
#       puts `git checkout -b #{previous_release}`
#       
#       puts "Removing tagged version '#{previous_release}' (now transformed in branch) ..."
#       puts `git tag -d #{previous_release}`
#       puts `git push heroku :refs/tags/#{previous_release}`
#       
#       puts "Pushing '#{previous_release}' to Heroku master ..."
#       puts `git push heroku +#{previous_release}:master --force`
#       
#       puts "Deleting rollbacked release '#{current_release}' ..."
#       puts `git tag -d #{current_release}`
#       puts `git push heroku :refs/tags/#{current_release}`
#       
#       puts "Retagging release '#{previous_release}' in case to repeat this process (other rollbacks)..."
#       puts `git tag -a #{previous_release} -m 'Tagged release'`
#       puts `git push --tags heroku`
#       
#       puts "Turning local repo checked out on master ..."
#       puts `git checkout master`
#       puts 'All done!'
#     else
#       puts "No release tags found - can't roll back!"
#       puts releases
#     end
#   end
# end

