# Setup

# install nginx
package 'nginx'

# install and start docker
docker_service 'default' do
  action [:create, :start]
end

