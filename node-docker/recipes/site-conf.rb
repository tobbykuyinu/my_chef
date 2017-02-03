
include_recipe 'deploy'

# loop over all application defined in OpsWork
node[:deploy].each do |application, deploy|
  Chef::Log.debug("Deploying application #{application} as a node.js app")

  # create the base deploy directories
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  # deploy the actual code by checking it out or downloading it in to the deploy dir.
  opsworks_deploy do
    deploy_data deploy
    app application
  end

end


node[:deploy].each do |application, deploy|
  Chef::Log.info("Skipping deploy::java-rollback application #{application} as it is not a Java app")
  template "/etc/nginx/sites-available/#{application}" do
    source "node.erb"
    owner 'root'
    group 'root'
    mode 00700
    variables({
      :x_SERVERHOSTNAME => node[:apps][application][:serverhostname],
      :x_SSLCA => node[:apps][application][:sslca],
      :x_SSLKEY => node[:apps][application][:sslkey],
      :x_SSLCRT => node[:apps][application][:sslcrt],
      :x_PORT => node[:apps][application][:port],
      :x_APPNAME => node[:apps][application][:appname]
    })
  end
end

execute 'Restart NGINX' do
  user 'root'
  command "service nginx restart"
end
