# Deploy

application = 'contentservice'

# pull docker image
docker_image 'tobbykuyinu/contentservice' do
  tag 'latest'
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
        -p 8082:8082 \
        -v /docker_logs:/var/log/applications \
        tobbykuyinu/contentservice
    EOH
end

# make hostname available
bash "update hosts" do
  cwd '/'
  user 'root'
  code <<-EOH
    echo "127.0.0.1 contentservice.api.com" >> /etc/hosts
  EOH
end

# restart proxy server
execute 'Restart NGINX' do
  user 'root'
  command "service nginx restart"
end