package :monit, :provides => :monitoring do
  description 'installs monit - a system monitoring utility which allows an admin to easily monitor files, processes, directories, or devices on your system.'
  
  apt "monit"
  
  requires :build_essential, :dependencies
  
  verify do
    has_executable "monit"
  end
end

package :monit_conf do
  description "Monit conf file"
  requires :monit
  install_path "/etc/monit/monitrc"
  
  transfer 'config/stack/files/monitrc.conf', "/tmp/monitrc" do
    post :install, "mv -f /tmp/monitrc /etc/monit/monitrc"
    post :install, "chown deploy:deploy /etc/monit/monitrc"
    post :install, "chmod u=rw,go= /etc/monit/monitrc"
    post :install, "chown -R deploy:deploy /var/lib/monit"
    post :install, "chmod -R u=rw,go=r /var/lib/monit"
  end
end

package :monit_init do
  description "Monit init.d script."
  requires :monit, :monit_conf
  install_path "/etc/init.d/monit"
  
  transfer "config/stack/files/monit_init.sh", "/tmp/monit" do
    post :install, "sudo mv -f /tmp/monit /etc/init.d/monit"
    post :install, "sudo chown root:root /etc/init.d/monit"
    post :install, "sudo chmod +x /etc/init.d/monit"
    post :install, "sudo /usr/sbin/update-rc.d -f monit defaults"
  end
end
