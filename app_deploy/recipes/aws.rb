node[:deploy].each do |application, deploy|

	directory "/tmp/.ssh" do
		owner "deploy"
		recursive true
	end

	cookbook_file "/tmp/.ssh/wrap-ssh4git.sh" do
		source "wrap-ssh4git.sh"
		owner "deploy"
		mode 00700
	end

	file "/tmp/.ssh/id_deploy" do
		content deploy[:scm][:ssh_key]
		mode    0600
		owner   'deploy'
		group   'www-data'
	end

	deploy application do
		repo         deploy[:scm][:repository]
		revision     deploy[:scm][:revision]
		deploy_to    deploy[:deploy_to]
		user         'deploy'
		group        'www-data'
		action       :deploy

		# git options
		enable_submodules false
		shallow_clone     true
		ssh_wrapper  "/tmp/.ssh/wrap-ssh4git.sh"
	end

	# writable directories
	[
		"#{node['server']['docroot']}/application/logs",
		"#{node['server']['docroot']}/application/cache"
	].each do |dir|
		directory dir do
			mode 0777
		end
	end

end