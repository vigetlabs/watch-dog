require 'uri'
require 'fileutils'

class Site < ActiveRecord::Base
  module Regex
    include URI::REGEXP::PATTERN
    # A general email regular expression. It allows top level domains (TLD) to be from 2 - 4 in length, any
    # TLD longer than that must be manually specified. The decisions behind this regular expression were made
    # by reading this website: http://www.regular-expressions.info/email.html, which is an excellent resource
    # for regular expressions.
    def self.email
      @email_regex ||= begin
        email_name_regex  = '[A-Z0-9_\.%\+\-]+'
        domain_head_regex = '(?:[A-Z0-9\-]+\.)+'
        domain_tld_regex  = '(?:[A-Z]{2,4}|museum|travel)'
        /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
      end
    end

    def self.http_url
      @http_url ||= Regexp.new("^(?:http|https):(?:#{NET_PATH})(?:\\?(?:#{QUERY}))?$", Regexp::EXTENDED, 'N')
    end
  end

  after_save :create_monit_check

  validates_presence_of :name
  validates_presence_of :url
  validates_presence_of :threshold
  validates_presence_of :email

  validates_uniqueness_of :url

  validates_format_of :email, :with => Regex.email,     :allow_nil => true
  validates_format_of :url,   :with => Regex.http_url,  :allow_nil => true

  def host
    URI.parse(url).host
  end
  
  def monit_check_name
    "#{host}_#{self.id}"
  end

  private

  def create_monit_check
    @template = MonitCheck.new(self)
    File.open(root_path('monitrc', RACK_ENV, "#{self.id}.monitrc"), 'w') do |file|
      file << @template.render
    end

    FileUtils.chmod 0700, root_path('monitrc', RACK_ENV, "#{self.id}.monitrc")
    system "#{File.join(settings(:monit_bin_dir), 'monit')} #{settings(:monit_cli_options)} reload"

    return true
  end
end
