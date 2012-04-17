require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'

require './lib/config' # SUT

describe Lad::Config do
  before do
    @dir  = File.join Dir.tmpdir, (0..16).to_a.map{|a| rand(16).to_s(16)}.join
    @file = File.join @dir, '.ladconfig'
    @cfg  = {
      'a_property' => 'property_value'
    }

    FileUtils.rm_rf @dir if Dir.exists? @dir
    FileUtils.mkdir @dir
  end

  after do
    FileUtils.rm_rf @dir
  end

  describe 'when loading a file that does not exist' do
    
    before do
      File.delete @file if File.exists? @file
    end

    it 'returns the default values' do
      Lad::Config.load(@dir, @cfg)['a_property'].must_equal @cfg['a_property']
    end
  end

  describe 'when loading a file that does exist' do
    before do
      File.open(@file, 'w') do |f| 
        f.puts '''a_property: file_value''' 
      end
    end

    it 'returns the values from that file' do
      Lad::Config.load(@dir, @cfg)['a_property'].must_equal 'file_value'
    end
  end
end