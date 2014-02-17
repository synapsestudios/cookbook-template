apt_repository 'php-54' do
	distribution  node['lsb']['codename']
	components    ['main']
	uri           'http://ppa.launchpad.net/ondrej/php5-oldstable/ubuntu'
	keyserver     'keyserver.ubuntu.com'
	key           'E5267A6C'
end

package "php5-dev" do
	action :upgrade
end

include_recipe 'php'

[
	'libssh2-php',
	'php5-cli',
	'php5-curl',
	'php5-gd',
	'php5-imagick',
	'php5-mcrypt',
	'php5-memcache',
	'php5-mysql',
	'php5-xcache',
	'php5-xdebug',
	'php5-xmlrpc'
].each do |pkg|
	package pkg do
		action :install
	end
end

php_pear "redis" do
	action :install
end