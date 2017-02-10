# Configuration

# login to docker repository
docker_registry 'https://index.docker.io/v1/' do
  username 'tobbykuyinu'
  password 'nkpokiripo'
  email 'tobbykuyinu@yahoo.com'
end

search("aws_opsworks_app").each do |app|
  application = app['shortname']

  # setup nginx proxy pass
  template "/etc/nginx/sites-available/#{application}" do
    source "domain_ngx_config.erb"
    owner 'root'
    group 'root'
    mode 00700
    variables({
      :x_SERVERHOSTNAME => app['domains'].join(" "),
      :x_PORT => app['environment']['NODE_PORT'],
      :x_APPNAME => application
    })
  end

  # enable proxy pass
  bash "enable site" do
    cwd '/'
    user 'root'
    code <<-EOH
      cp /etc/nginx/sites-available/#{application} /etc/nginx/sites-enabled/
    EOH
  end

  # create directory for env files
  directory "/srv/env" do
    owner 'root'
    group 'root'
    mode '00700'
  end

  # create docker logs directory
  directory "/srv/docker_logs" do
    owner 'root'
    group 'root'
    mode '00700'
  end

  # create docker logs file for app
  file "/srv/docker_logs/#{application}" do
    owner 'root'
    group 'root'
    mode '00700'
  end

  env_variables = Array.new

  # populate env for application
  app['environment'].each do |env, val|
    env_variables << "#{env}=#{val}"
  end

  env_vars_string = env_variables.join("\n")

  file "/srv/env/#{application}" do
      content <<-EOH
  #{env_vars_string}
      EOH
      mode '00700'
      owner 'root'
      group 'root'
  end
end