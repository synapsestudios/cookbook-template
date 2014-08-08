# Create config file which sets the default MySQL charset and collation
template "#{node[:mysql][:confd_dir]}/charset.cnf" do
  source "charset.cnf.erb"
  mode "0644"
  variables(
    :encoding  => node[:mysql_charset][:encoding],
    :collation => node[:mysql_charset][:collation]
  )
end
