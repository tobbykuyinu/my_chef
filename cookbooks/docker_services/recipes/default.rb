#
# Cookbook:: docker_services
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'nginx'

docker_image 'ubuntu' do
    tag '14.04'
    action :pull
end

#curl -L https://www.opscode.com/chef/install.sh | bash
