bash 'update apt-get repository' do
    user 'root'
    code <<-EOH
      curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
      EOH
  end

execute 'install nodejs' do
      user "root"
      command "apt-get install -y nodejs"
end
