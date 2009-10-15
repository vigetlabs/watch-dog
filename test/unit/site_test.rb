require "test_helper"

class SiteTest < Test::Unit::TestCase
  context 'A site' do
    setup do
      @site = Site.factory
    end
    
    should 'be invalid without name' do
      @site.name = ""
      assert !@site.valid?
      assert_contains @site.errors, [:name, :not_present]
    end
    
    should 'be invalid without email' do
      @site.email = ""
      assert !@site.valid?
      assert_contains @site.errors, [:email, :not_present]
    end
    
    should 'be invalid without url' do
      @site.url = ""
      assert !@site.valid?
      assert_contains @site.errors, [:url, :not_present]
    end
    
    should 'be invalid without threshold' do
      @site.threshold = ""
      assert !@site.valid?
      assert_contains @site.errors, [:threshold, :not_present]
    end
    
    should 'be invalid with invalid email address' do
      @site.email = "bogus.email_address"
      assert !@site.valid?
      assert_contains @site.errors, [:email, :format]
    end
    
    should 'be invalid with bad URL' do
      @site.url = "202 Rigsbee Ave, Durham, NC"
      assert !@site.valid?
      assert_contains @site.errors, [:url, :format]
    end
    
    should 'be invalid with ftp URL' do
      @site.url = "ftp://www.example.com/some/path/to/a_file.txt"
      assert !@site.valid?
      assert_contains @site.errors, [:url, :format]
    end
    
    should 'return the host part of the URL provided' do
      assert_equal @site.host, 'www.google.com'
    end
    
    should 'require URL to be unique' do
      @site.save
      another_site = Site.factory(:url => @site.url)
      assert !another_site.valid?
      assert_contains another_site.errors, [:url, :not_unique]
    end
    
    should 'create monitrc file' do
      @site.save
      assert File.size?(root_path('monitrc', "#{@site.id}.monitrc"))
    end
    
    teardown do
      unless @site.new?
        FileUtils.rm_f(root_path('monitrc', "#{@site.id}.monitrc"))
      end
      @site = nil
    end
  end
end
