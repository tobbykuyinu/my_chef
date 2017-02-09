#
# Cookbook:: docker_services
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'nginx'

docker_registry 'https://index.docker.io/v1/' do
  username 'tobbykuyinu'
  password 'nkpokiripo'
  email 'tobbykuyinu@yahoo.com'
end

docker_image 'ubuntu' do
    tag '14.04'
    action :pull
end

docker_image 'carmudi/apisearch' do
  tag 'latest'
  action :pull
end

docker_container 'apisearch' do
    repo 'carmudi'
end

#curl -L https://www.opscode.com/chef/install.sh | bash
