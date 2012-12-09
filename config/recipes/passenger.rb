namespace :deploy do
  [:start, :stop, :restart].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

namespace :passenger do
  desc "Restart Application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && touch tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end