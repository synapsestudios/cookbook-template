web_app node['server']['server_name'] do
	server_name     node['server']['server_name']
	server_aliases  node['server']['server_aliases']
	docroot         node['server']['webroot']
	allow_override  ['All']
end

apache_module 'php5' do
	filename "libphp5.so"
end