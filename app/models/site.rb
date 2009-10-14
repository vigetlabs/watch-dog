require 'uri'

class Site < Ohm::Model
  module Regex
    include URI::REGEXP::PATTERN
    # A general email regular expression. It allows top level domains (TLD) to be from 2 - 4 in length, any
    # TLD longer than that must be manually specified. The decisions behind this regular expression were made
    # by reading this website: http://www.regular-expressions.info/email.html, which is an excellent resource
    # for regular expressions.
    def self.email
      return @email_regex if @email_regex
      email_name_regex  = '[A-Z0-9_\.%\+\-]+'
      domain_head_regex = '(?:[A-Z0-9\-]+\.)+'
      domain_tld_regex  = '(?:[A-Z]{2,4}|museum|travel)'
      @email_regex = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
    end

    def self.http_url
      return @http_url if @http_url
      @http_url = Regexp.new("^(?:http|https):(?:#{NET_PATH})(?:\\?(?:#{QUERY}))?$", Regexp::EXTENDED, 'N')
    end
  end

  include ActiveSupport::Callbacks
  define_callbacks :before_save, :after_save

  def save_with_callbacks #:nodoc:
    return false if callback(:before_save) == false
    if result = save_without_callbacks
      callback(:after_save)
    end
    result
  end
  private :save_with_callbacks

  # alias_method_chain :save, :callbacks

  attribute :name
  attribute :url
  attribute :match_text
  attribute :threshold
  attribute :email
  list :test_record

  index :url

  after_save :create_monit_check

  def validate
    assert_present :name
    assert_present :url
    assert_present :threshold
    assert_present :email

    assert_format :email, Regex.email
    assert_format :url, Regex.http_url
  end

  def host
    URI.parse(url).host
  end

  private
    def create_monit_check

    end

end
