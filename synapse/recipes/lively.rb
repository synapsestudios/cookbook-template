package "git" do
    action :install
end

npm_package "gulp"
npm_package "bower"

git "lively" do
    repository "https://github.com/synapsestudios/lively"
    revision "master"
    user node['server']['user']
    destination node['lively']['docroot']
    action :sync
end

npm_package "npm-install-lively" do
    path node['lively']['docroot']
    action :install_from_json
end

execute "bower-install-lively" do
    creates "bower_components"
    cwd node['lively']['docroot']
    command "bower install"
    user node['server']['user']
    environment ({ "HOME" => "/home/#{node['server']['user']}" })
end

web_app node["lively"]["server_name"] do
    server_name    node["lively"]["server_name"]
    server_aliases node["lively"]["server_aliases"]
    template       "lively.conf.erb"
end

execute "lively-delete-config-files" do
    cwd "/home/#{node['server']['user']}"
    command "rm -rf #{node['lively']['confroot']}/"
    user node['server']['user']
    environment ({ "HOME" => "/home/#{node['server']['user']}" })
end

execute "lively-copy-config" do
    cwd "/home/#{node['server']['user']}"
    command "cp -a #{node['server']['docroot']}/docs/config/ #{node['lively']['confroot']}/"
    user node['server']['user']
    environment ({ "HOME" => "/home/#{node['server']['user']}" })
end

execute "lively-inject-hostname" do
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
