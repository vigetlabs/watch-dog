require "test_helper"

class SiteTest < Test::Unit::TestCase
  context 'A site' do
    setup do
      @site = Factory.build(:site)
    end

    should 'be invalid without name' do
      @site.name = ""
      assert !@site.valid?
      assert_contains @site.errors[:name], "can't be blank"
    end

    should 'be invalid without email' do
      @site.email = ""
      assert !@site.valid?
      assert_contains @site.errors[:email], "can't be blank"
    end

    should 'be invalid without url' do
      @site.url = ""
      assert !@site.valid?
      assert_contains @site.errors[:url], "can't be blank"
    end

    should 'be invalid without threshold' do
      @site.threshold = ""
      assert !@site.valid?
      assert_contains @site.errors[:threshold], "can't be blank"
    end

    should 'be invalid with invalid email address' do
      @site.email = "bogus.email_address"
      assert !@site.valid?
      assert_contains @site.errors[:email], "is invalid"
    end

    should 'be invalid with bad URL' do
      @site.url = "202 Rigsbee Ave, Durham, NC"
      assert !@site.valid?
      assert_contains @site.errors[:url], "is invalid"
    end

    should 'be invalid with ftp URL' do
      @site.url = "ftp://www.example.com/some/path/to/a_file.txt"
      assert !@site.valid?
      assert_contains @site.errors[:url], "is invalid"
    end

    should 'return the host part of the URL provided' do
      assert_equal @site.host, 'www.google.com'
    end

    should 'require URL to be unique' do
      @site.save
      another_site = Factory.build(:site, :url => @site.url)
      assert !another_site.valid?
      assert_contains another_site.errors[:url], "has already been taken"
    end

    should 'create monitrc file' do
      @site.save

      assert File.file?(root_path('monitrc', RACK_ENV, "#{@site.id}.monitrc"))
      assert File.size?(root_path('monitrc', RACK_ENV, "#{@site.id}.monitrc"))

      permissions = sprintf('%o', File.stat(root_path('monitrc', RACK_ENV, "#{@site.id}.monitrc")).mode)
      assert_equal permissions[-3..-1], "700"
    end

    should 'reload monit' do
      @site.class_eval do
        def system(*args); end
      end
      @site.expects(:system).with("#{File.join(settings(:monit_bin_dir), 'monit')} #{settings(:monit_cli_options)} reload").returns(true)

      @site.save
    end
    
    context 'that has been saved' do
      setup do
        @site.save
      end
      
      should 'remove monitrc file when destroyed' do
        @site.destroy
        assert !File.exist?(root_path('monitrc', RACK_ENV, "#{@site.id}.monitrc"))
      end
      
      should 'reload monit when destroyed' do
        @site.class_eval do
          def system(*args); end
        end
        @site.expects(:system).with("#{File.join(settings(:monit_bin_dir), 'monit')} #{settings(:monit_cli_options)} reload").returns(true)
        
        @site.destroy
      end
    end

    teardown do
      unless @site.new_record?
        FileUtils.rm_f(root_path('monitrc', RACK_ENV, "#{@site.id}.monitrc"))
      end
      @site = nil
    end
  end
end
