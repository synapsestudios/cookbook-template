package "git" do
    action :install
end

git "lively" do
    repository "https://github.com/synapsestudios/lively"
    revision "master"
    user node['server']['user']
    destination "/home/#{node['server']['user']}/lively"
    action :sync
end

execute "npm-install-gulp" do
    command "npm -g install gulp bower"
end

execute "npm-install-lively" do
    creates "node_modules"
    cwd "/home/#{node['server']['user']}/lively"
    command "npm install"
    user node['server']['user']
    environment ({ "HOME" => "/home/#{node['server']['user']}" })
end

execute "bower-install-lively" do
    creates "node_modules"
    cwd "/home/#{node['server']['user']}/lively"
    command "bower install"
    user node['server']['user']
    environment ({ "HOME" => "/home/#{node['server']['user']}" })
end

# Default config for lively
template "/home/#{node['server']['user']}/lively/application/config.js" do
    source "lively-config.erb"
    mode 0655
end
