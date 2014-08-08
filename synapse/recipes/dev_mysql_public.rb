execute "make-mysql-server-public" do
    cwd "/etc/mysql"
    command "sed -i 's/bind-address/# bind-address/g' my.cnf"
    user 'root'
    environment ({ "HOME" => "/home/#{node['server']['user']}" })
    notifies :reload, 'service[mysql]'
end
