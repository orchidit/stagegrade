set :application, 'StageGrade'
set :user, 'stagegrade' # DH username

# Version Control Config
set :scm, :git
set :scm_username, 'martingo@martingordon.org'
set :repository, "ssh://martingo@martingordon.org/home/martingo/subdomains.memecache.net/git/stagegrade"
set :deploy_via, :remote_cache
set :scm_verbose, true

# Additional Settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
ssh_options[:keys] = %w(/home/#{user}/.ssh/id_rsa) # If you are using ssh_keys
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false

desc "Set Branch and Environment"
before "deploy:update" do
  set(:branch) { Capistrano::CLI.ui.ask "Branch (none for master): "}

  set :env, "dev" unless exists?(:env)
  set :branch, "master" if branch.nil? or branch.empty?
  set :do_backup, false unless exists?(:do_backup)
  
  if env == "production"
    puts "******************* DEPLOYING TO PRODUCTION FROM BRANCH '#{branch}' *******************"
    set :domain, 'stagegrade.com'
    set :app_name, domain
  elsif env == "dev"
    puts "******************* DEPLOYING TO DEV FROM BRANCH '#{branch}' *******************"
    set :domain, 'dev.stagegrade.com'
    set :app_name, domain
  end
  
  # deployment location
  set :applicationdir, "/home/#{user}/#{app_name}"
  set :deploy_to, applicationdir
  
  # roles (servers)
  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true

  set :backup_dir, "/home/#{user}/backups"
  backup if do_backup
end

# deploy
#   deploy:update
#     deploy:update_code
#     deploy:symlink
#   deploy:restart

desc "Revert to repository's environment and schema files."
before "deploy:update_code" do
  run "cd #{current_path} && git checkout config/environment.rb"
  run "cd #{current_path} && git checkout db/schema.rb"
end

# after "deploy:update_code" do
# end

desc "Link shared files"
before "deploy:symlink" do
  run "rm -drf #{release_path}/public/system"
  run "ln -s #{shared_path}/system #{release_path}/public/system"

  run "rm -drf #{release_path}/tmp/cache"
  run "ln -s #{shared_path}/tmp/cache #{release_path}/tmp/cache"
end

desc "Use proper environment file."
after "deploy:symlink" do
  run "cp #{current_path}/config/environment.#{env}.rb #{current_path}/config/environment.rb"
  run "cp #{current_path}/config/database.server.yml #{current_path}/config/database.yml"
end

after :deploy do
  "passenger:restart"
end