#
# Cookbook:: docker_services
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'nginx'
application = 'contentservice'

docker_service 'default' do
  action [:create, :start]
end

docker_registry 'https://index.docker.io/v1/' do
  username 'tobbykuyinu'
  password 'nkpokiripo'
  email 'tobbykuyinu@yahoo.com'
end

template "/etc/nginx/sites-available/#{application}" do
  source "domain_ngx_config.erb"
  owner 'root'
  group 'root'
  mode 00700
  variables({
    :x_SERVERHOSTNAME => 'contentservice.api.com', #node[:apps][application][:serverhostname],
    :x_PORT => 8082, #node[:apps][application][:port],
    :x_APPNAME => 'contentservice' #node[:apps][application][:appname]
  })
end

bash "enable site" do
  cwd '/'
  user 'root'
  code <<-EOH
    cp /etc/nginx/sites-available/#{application} /etc/nginx/sites-enabled/
  EOH
end

bash "update hosts" do
  cwd '/'
  user 'root'
  code <<-EOH
    echo "127.0.0.1 contentservice.api.com" >> /etc/hosts
  EOH
end

directory "/srv/env" do
  owner 'root'
  group 'root'
  mode '00700'
end

directory "/srv/docker_logs" do
  owner 'root'
  group 'root'
  mode '00700'
end

file "/srv/docker_logs/#{application}" do
  owner 'root'
  group 'root'
  mode '00700'
end

file "/srv/env/#{application}" do
    content <<-EOH
NODE_PORT=8082
NODE_ENV=development
CONTENTFUL_CONTENT_DELIVERY_API_KEY=41c4801c0cf1c52610744a1b44daabbbf7757d7bf0ac655b26b8338443adfc7e
CONTENTFUL_CONTENT_PREVIEW_API_KEY=4ea7de80857a5c99074ccf82139212f64c1c592b8eeec266b663c8e489ba7a13
CONTENTFUL_SPACE_ID=6px19mtg14gc
API_SEARCH_URL_TIER_1=http://api-search-staging.eu-central-1.elasticbeanstalk.com/1
API_SEARCH_URL_TIER_2=http://api-search-staging.eu-central-1.elasticbeanstalk.com/1
GOOGLE_API_CLIENT_EMAIL=google-analytics-service@content-service-156115.iam.gserviceaccount.com
GOOGLE_API_PRIVATE_KEY='-----BEGIN PRIVATE KEY-----\\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQChf+O/uV93cU+X\\nGIHgs/F3z1+Gee7gO6v2ugSlaFGMDCMiIZsi5KQVDdgdDA8do5zKZiQ4wrGJwMXq\\nXHnHjT710H5gUoi5k+m+J001DwjXryWyM/vQFyfn1S67OxkSHb3+jjp5AomGS6PT\\ntm9qvYDivL8sli4yhmvRh4ijC8+APDQ157aNFQq79rieAd52UOVj7Y1npZNYo36g\\nbmskujiGch/Wg9w8Omg6I7UGTrhfeeafSnPxM8fIQNo4sj8gZfpYaV/EMcaD4wxI\\n26O4dl5zecoWBsSHP3WOClSqqA9Qa95AFUVWNQ8ZkXPG2NitX6QK/Aqa/zG7G62M\\nn5lPe4xdAgMBAAECggEABh0iURLCc3IdsjmiSRBm1sNJ+XxKN8DqjKeUH3Loi2W2\\nOseM6PBA6e8hPFBFjjiwadUeD+wG7pEWrP2dOpm1RXcEIb9eH7Biy+kO+jA8hHXD\\n9pATO1h1EUi3wSzGkTIBDE70Fbqr3CKm7A/e/ep4o5zDm/t/ejgugrsfyBRdYZxW\\ndF7mcjYvSAde7UgZeec2pPiAoODcIEqkxjxZw0zY9y+GzFHBQ+a139zTWkTmGFCV\\nqIdf0pXfpLyDmpqpF09yYdBBw3KrWQyw1YjK1zoS0bCcLlidWCJOMkvykqE3KhA6\\n+QujRa4QMDq7od5r4GWQBl4aFPFlROmYP52vv3WTgQKBgQDNDYd9uJpzsF6fCDa+\\nPv5KB72tPNUUEoV6e96EEF1h4hhwtxJ6LVrmvQQdXn4KpHBg7HOhp0qVxdhyLkey\\nLpf33gd8JX7tk1ZmXGi+2OiMNxmGWrI7bhBCL+RfVaVYsWM/hu0mdDXwgpcYX+uy\\nR13llk31/nu0d/Ls6x/tb2pzIQKBgQDJoCLYppmY+9fE6CG47a5iYigTNEHK/tc5\\nmsxeZYFxAIvVUR7g6C53Ag48OXw8g/hLFAkJL9Yvkr8LyCUJLmvpykjBfxRgp+db\\n6tYeWEnRb04DqKzKO8mHtdcJL+LZxzwa7be4Y1rdJAnzvjbz9czewnfCXnNe5PdP\\nhOxj1m/tvQKBgGcVvR7cFnHAoeELbRH5czdeauHTqj9cDFSGP1hfLcMOukC4GIbp\\nlEBZl9736R+KiaCAXqVPB/UBsI2+bHbMa8PFkDe+VfAz2QS+wj3nqAkNjjx4DhBI\\nhc3wa7vtv6E2FHIUb9acJ53Q2Qr89e37aN4J0QmxNRmGD89BaRyhnX9hAoGATDPC\\nl8E3cfNU1C2reRoTe0l/vepVJ2RzcWkI7nBMoKnFL6UOF5CI5x+Ww7oyMyjpcW6s\\nD5XNzIMYw1osbTDnRh/WqZLe37z1mu7BaAyUMZxwjr90Nqar/yeBkw5PHWHIXKEV\\ne5HJaKTTQhTU7hUrDdHPs11BG09MDPi+4ujLur0CgYEAqk5tRcMnqBWfsiMyW5gR\\nN6jH2b1F9wUfiOdvHrBQQm414GjO/MbUAX+UXWOLdMBF48f/3fJ4RA1QbS07/nLt\\n0KLgvVO2Q+FppqP4w/LTXSIuvvFyqL4QbXE9E2XE4m1WIywwQvn/hwghhZaYuikr\\nvB000eaRZGg5Md8jHWxRQB8=\\n-----END PRIVATE KEY-----\\n'
VN_ANALYTICS_ID=ga:83401426
PH_ANALYTICS_ID=ga:84287328
ID_ANALYTICS_ID=ga:83400134
MM_ANALYTICS_ID=ga:83396858
MX_ANALYTICS_ID=ga:83398940
BD_ANALYTICS_ID=ga:83400223
PK_ANALYTICS_ID=ga:83398836
LK_ANALYTICS_ID=ga:87779983
SA_ANALYTICS_ID=ga:83399342
QA_ANALYTICS_ID=ga:83398340
        EOH
    mode '00700'
    owner 'root'
    group 'root'
end

docker_image 'tobbykuyinu/contentservice' do
  tag 'latest'
  action :pull
end

docker_container "#{application}" do
  action :remove
end

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

execute 'Restart NGINX' do
  user 'root'
  command "service nginx restart"
end

#curl -L https://www.opscode.com/chef/install.sh | bash
