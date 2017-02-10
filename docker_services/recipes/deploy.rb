# Deploy

search("aws_opsworks_app").each do |app|
  application = app['shortname']

  # pull docker image
  docker_image "#{app['environment']['DOCKER_IMAGE']" do
    tag "#{app['environment']['DOCKER_TAG']"
    action :pull
  end

  # remove existing container
  docker_container "#{application}" do
    action :remove
  end

  # start container
  bash 'run_app' do
    cwd '/'
    code <<-EOH
      docker run -d \
          --env-file=/srv/env/#{application} \
          --name=#{application} \
          -p #{app['environment']['NODE_PORT']}:#{app['environment']['NODE_PORT']} \
          -v /docker_logs:/var/log/applications \
          #{app['environment']['DOCKER_IMAGE']}
      EOH
  end
end

# restart proxy server
execute 'Restart NGINX' do
  user 'root'
  command "service nginx restart"
end