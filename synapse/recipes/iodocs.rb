package "git" do
    action :install
end

git "iodocs" do
    repository "https://github.com/vky/iodocs"
    revision "feature/content-parameters"
    user node['server']['user']
    destination "/home/#{node['server']['user']}/iodocs"
    action :checkout
end

execute "npm-install-iodocs" do
    creates "node_modules"
    cwd "/home/#{node['server']['user']}/iodocs"
    command "npm install"
end

# Default config for iodocs
template "/home/#{node['server']['user']}/iodocs/config.json" do
  source "iodocs-config.erb"
  mode 0655
end

# simple init.d for iodocs
template "/etc/init.d/iodocs" do
  source "iodocs-init.erb"
  mode 0655
end

service "iodocs" do
  supports :status => true, :start => true, :stop => true, :restart => true
  action [ :enable, :restart ]
end
