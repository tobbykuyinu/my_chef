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
