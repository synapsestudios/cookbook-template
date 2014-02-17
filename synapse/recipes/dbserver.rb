include_recipe 'mysql::ruby'
include_recipe 'database'
include_recipe 'database::mysql'

mysql_connection = {
	:host => 'localhost',
	:username => 'root',
	:password => 'synapse1'
}

mysql_database node['server']['database_name'] do
	connection mysql_connection
	action :create
end