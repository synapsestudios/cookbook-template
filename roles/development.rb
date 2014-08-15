name "vagrant"

override_attributes(
	"server" => {
		"user"           => "vagrant",
		"webroot"        => "/vagrant/public",
		"docroot"        => "/vagrant",
		"database_name"  => "database_vm",
		"server_name"    => "%DEV_HOST%",
		"server_aliases" => [ "%DEV_HOST%"]
	},
	"lively" => {
		"confroot"       => "/home/vagrant/docs",
		"docroot"        => "/home/vagrant/lively",
		"server_name"    => "lively.%DEV_HOST%",
		"server_aliases" => [ "lively.%DEV_HOST%" ]
	},
	"mysql" => {
		"server_root_password"   => "synapse1",
		"server_repl_password"   => "synapse1",
		"server_debian_password" => "synapse1",
		"remove_anonymous_users" => true,
		"allow_remote_root"      => true,
		"remove_test_database"   => true
	},
	"etc_environment" => {
		"APP_ENV"  => 'development',
		"APP_NAME" => '%DEV_APP_NAME%'
	},
	"php" => {
		"directives" => {
			"date.timezone"        => "America/Phoenix",
			"upload_max_filesize"  => "8M",
			"session.save_handler" => "redis",
			"session.save_path"    => "tcp://localhost:6379"
		}
	}
)

run_list(
	"recipe[app_deploy::shutdown_worker]",
	"recipe[etc_environment]",
	"recipe[apt]",
	"recipe[apache2]",
	"recipe[apache2::mod_php5]",
	"recipe[apache2::mod_env]",
	"recipe[apache2::mod_rewrite]",
	"recipe[apache2::mod_proxy]",
	"recipe[apache2::mod_proxy_http]",
	"recipe[mysql]",
	"recipe[mysql::server]",
	"recipe[mysql::client]",
	"recipe[synapse::mysql_charset]",
	"recipe[nodejs::install_from_package]",
	"recipe[composer]",
	"recipe[python]",
	"recipe[supervisor]",
	"recipe[synapse::webserver]",
	"recipe[synapse::appserver]",
	"recipe[synapse::dbserver]",
	"recipe[synapse::cacheserver]",
	"recipe[synapse::dev_utils]",
	"recipe[synapse::dev_hosts]",
	"recipe[synapse::dev_mysql_public]",
	"recipe[app_deploy::web]",
	"recipe[app_deploy::worker]",
	"recipe[app_deploy]",
	"recipe[synapse::lively]"
)
