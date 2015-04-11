Vagrant.configure("2") do |config|

  # tunables
  env_prefix  = ENV['DRUPAL_VAGRANT_ENV_PREFIX'] || 'DRUPAL_VAGRANT'
  ip          = ENV["#{env_prefix}_IP"] || '10.33.36.41'
  project     = ENV["#{env_prefix}_PROJECT"] || 'scylla'
  # end tunables

  config.vm.box     = "palantir/ubuntu-default"
  path = "/var/www/sites/#{project}.dev"

  config.vm.synced_folder ".", "/vagrant", :disabled => true
  config.vm.synced_folder ".", path, :nfs => true
  config.vm.hostname = "#{project}.dev"

  config.vm.network :private_network, ip: ip

  config.vm.provision :shell, inline: <<SCRIPT
  set -ex
  /opt/phantomjs --webdriver=8643 &> /dev/null &
  #su vagrant -c 'cd #{path} && composer install;
  #cd #{path} && build/install.sh;'

  #   WARNING! Total hack!
  sudo echo "xdebug.max_nesting_level=500" >> /etc/php5/apache2/conf.d/20-xdebug.ini;
  sudo service apache2 restart;
SCRIPT
end