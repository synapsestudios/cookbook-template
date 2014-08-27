execute "make-mysql-server-public" do
    cwd "/etc/mysql"
    command "sed -i 's/bind-address/# bind-address/g' my.cnf"
    user 'root'
    environment ({ "HOME" => "/home/#{node['server']['user']}" })
    notifies :reload, 'service[mysql]'
end

execute "restart-mysql-server" do
    cwd "/etc/mysql"
    command "service mysql restart"
    user 'root'
    environment ({ "HOME" => "/home/#{node['server']['user']}" })
end
