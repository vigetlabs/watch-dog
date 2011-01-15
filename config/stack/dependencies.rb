package :dependencies do
  apt %w(libglib2.0-dev cmake libpcre3 libpcre3-dev libxml2-dev 
    libxml2 libxslt-dev libgcrypt11-dev libreadline5-dev zlib1g-dev zlibc
    libedit-dev gettext logrotate libcurl4-openssl-dev
    libevent-dev libevent-1.4-2 openssl libssl-dev)
  requires :build_essential
end
