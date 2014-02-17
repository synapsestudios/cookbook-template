# download and run pagekite's installer
execute "download pagekite.py" do
	command "curl http://pagekite.net/pk/ | sudo bash"
end

execute "disable sendfile" do
	command "echo 'EnableSendFile off' >> /etc/apache2/apache2.conf"
	notifies :reload, "service[apache2]", :immediately
end