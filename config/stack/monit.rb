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
    post :install, "chown root:root /etc/monit/monitrc"
    post :install, "chmod u=rw,go= /etc/monit/monitrc"
  end
end
