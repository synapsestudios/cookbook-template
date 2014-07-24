# Add hosts entry for the server name, so that it points to this server
# Meant to be used in development only; needed for Lively's Oauth Proxy
hostsfile_entry '127.0.0.1' do
    hostname  node['server']['server_name']
    action    :create
end
