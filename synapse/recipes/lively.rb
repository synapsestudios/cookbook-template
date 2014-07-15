package "git" do
    action :install
end

git "lively" do
    repository "https://github.com/synapsestudios/lively"
    revision "master"
    user node['server']['user']
    destination "#{node['lively']['docroot']}"
    action :sync
end

execute "npm-install-gulp" do
    command "npm -g install gulp bower"
end

execute "npm-install-lively" do
    creates "node_modules"
    cwd "#{node['lively']['docroot']}"
    command "npm install"
    user node['server']['user']
    environment ({ "HOME" => "/home/#{node['server']['user']}" })
end

execute "bower-install-lively" do
    creates "bower_components"
    cwd "#{node['lively']['docroot']}"
    command "bower install"
    user node['server']['user']
    environment ({ "HOME" => "/home/#{node['server']['user']}" })
end

web_app node["lively"]["server_name"] do
    server_name    node["lively"]["server_name"]
    server_aliases node["lively"]["server_aliases"]
    template       "lively.conf.erb"
end

execute "lively-copy-config" do
    creates "docs"
    cwd "/home/#{node['server']['user']}"
    command "cp -a #{node['server']['docroot']}/docs/ #{node['lively']['confroot']}/"
    user node['server']['user']
    environment ({ "HOME" => "/home/#{node['server']['user']}" })
end

execute "lively-inject-hostname" do
    creates "docs"
    cwd "#{node['lively']['confroot']}"
    command "sed -i 's/%HOSTNAME%/#{node['server']['server_name']}/g' config.*.js"
    user node['server']['user']
    environment ({ "HOME" => "/home/#{node['server']['user']}" })
end

# Default config for lively
template "#{node['lively']['docroot']}/application/config.js" do
    source "lively-config.erb"
    mode 0655
end

supervisor_service "lively" do
    user node['server']['user']
    directory "#{node['lively']['docroot']}"
    action [:enable, :start]
    autostart true
    autorestart true
    command "gulp"
    environment ({ "HOME" => "/home/#{node['server']['user']}" })
end
