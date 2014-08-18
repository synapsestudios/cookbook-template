execute "install:run" do
  cwd node['server']['docroot']
  environment node['etc_environment']
  command "./console install:run"
end
