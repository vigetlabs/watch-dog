package :nginx_passenger, :provides => [:webserver, :appserver] do
  description "Nginx with the Passenger module"
  version "0.8.54"
  install_path "/usr/local/nginx"
  
  source "http://sysoev.ru/nginx/nginx-#{version}.tar.gz" do
    custom_install "sudo /usr/local/bin/passenger-install-nginx-module " +
      "--auto --prefix=#{install_path} --nginx-source-dir=/usr/local/build/nginx-#{version} " +
      "--extra-configure-flags='--with-http_ssl_module'"
    post :install, "ln -s #{install_path}/sbin/nginx /usr/local/bin/nginx"
    post :install, "chown -R deploy /usr/local/nginx/logs"
    post :install, "mkdir /var/www"
    post :install, "chown -R deploy /var/www"
  end
  
  verify do
    has_directory "/usr/local/nginx"
    has_file "/usr/local/nginx/conf/nginx.conf"
    has_executable "/usr/local/nginx/sbin/nginx"
  end
  
  requires :ruby_enterprise, :build_essential, :dependencies
end

package :nginx_init do
  description "Nginx init.d file for Ubuntu"
  install_path "/etc/init.d"
  
  transfer 'config/stack/files/nginx-init.sh', '/tmp/nginx' do
    post :install, "mv -f /tmp/nginx /etc/init.d/nginx"
    post :install, "chmod +x /etc/init.d/nginx"
    post :install, "/usr/sbin/update-rc.d -f nginx defaults"
    post :install, "/etc/init.d/nginx start"
  end
  
  requires :nginx_passenger
end

package :nginx_conf do
  description "Sample Nginx conf file"
  install_path "/usr/local/nginx/conf/nginx.conf"
  
  transfer 'config/stack/files/nginx.conf.sample', '/tmp/nginx.conf' do
    post :install, "mv -f /tmp/nginx.conf /usr/local/nginx/conf/nginx.conf"
  end
  
  requires :nginx_passenger
end
