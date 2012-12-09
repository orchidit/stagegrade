task :backup, :roles => :db, :only => { :primary => true } do
  filename = "#{backup_dir}/#{app_name}.dump.#{DateTime.now.strftime("%Y%m%d.%H%M%S")}.sql.bz2"
  text = capture "cat #{deploy_to}/current/config/database.yml"
  yaml = YAML::load(text)

  on_rollback { run "rm #{filename}" }
  run "mysqldump -u #{yaml[env]['username']} -p #{yaml[env]['password']} | bzip2 -c > #{filename}" do |ch, stream, out|
    ch.send_data "#{yaml[env]['password']}\n" if out =~ /^Enter password:/
  end
end