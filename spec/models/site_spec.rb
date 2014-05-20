require 'spec_helper'

describe Site do
  subject { build(:site) }

  it 'is invalid without name' do
    subject.name = ""
    subject.should be_invalid
    subject.errors[:name].should include("can't be blank")
  end

  it 'is invalid without email' do
    subject.email = ""
    subject.should be_invalid
    subject.errors[:email].should include("can't be blank")
  end

  it 'is invalid without url' do
    subject.url = ""
    subject.should be_invalid
    subject.errors[:url].should include("can't be blank")
  end

  it 'is invalid without threshold' do
    subject.threshold = ""
    subject.should be_invalid
    subject.errors[:threshold].should include("can't be blank")
  end

  it 'is invalid with invalid email address' do
    subject.email = "bogus.email_address"
    subject.should be_invalid
    subject.errors[:email].should include("is invalid")
  end

  it 'is invalid with bad URL' do
    subject.url = "202 Rigsbee Ave, Durham, NC"
    subject.should be_invalid
    subject.errors[:url].should include("is invalid")
  end

  it 'is invalid with ftp URL' do
    subject.url = "ftp://www.example.com/some/path/to/a_file.txt"
    subject.should be_invalid
    subject.errors[:url].should include("is invalid")
  end

  it 'returns the host part of the URL provided' do
    subject.host.should == 'www.google.com'
  end

  it 'requires URL to be unique' do
    subject.save
    another_site = build(:site, :url => subject.url)
    another_site.should be_invalid
    another_site.errors[:url].should include("has already been taken")
  end

  it 'creates a monitrc file' do
    subject.save

    File.file?(root_path('monitrc', RACK_ENV, "#{subject.id}.monitrc")).should be
    File.size?(root_path('monitrc', RACK_ENV, "#{subject.id}.monitrc")).should be

    permissions = sprintf('%o', File.stat(root_path('monitrc', RACK_ENV, "#{subject.id}.monitrc")).mode)
    permissions[-3..-1].should == "600"
  end

  it 'reloads monit' do
    Monit.should_receive(:reload)
    subject.save
  end
  
  context 'that has been saved' do
    before do
      subject.save
    end
    
    it 'removes monitrc file when destroyed' do
      subject.destroy
      File.exist?(root_path('monitrc', RACK_ENV, "#{subject.id}.monitrc")).should be_false
    end
    
    it 'reloads monit when destroyed' do
      Monit.should_receive(:reload)
      subject.destroy
    end
  end

  after do
    unless subject.new_record?
      FileUtils.rm_f(root_path('monitrc', RACK_ENV, "#{subject.id}.monitrc"))
    end
  end
end
