module Monit
  extend self
  
  def reload
    system "#{File.join(settings(:monit_bin_dir), 'monit')} #{settings(:monit_cli_options)} reload"
  end
end