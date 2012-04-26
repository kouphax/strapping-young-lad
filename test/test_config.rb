require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'
require './test/testutils'

require './lib/config' # SUT

describe Lad::Config do
  include TestUtils

  before &:prepare_files_and_folders
  after  &:clear_temp_files

  describe 'when loading a file that does not exist' do
    
    before do
      File.delete @cfgfile if File.exists? @cfgfile
    end

    it 'returns the default values' do
      Lad::Config.load(@dir, @cfg)['a_property'].must_equal @cfg['a_property']
    end
  end

  describe 'when loading a file that does exist' do
    before do
      File.open(@cfgfile, 'w') do |f| 
        f.puts '''a_property: file_value''' 
      end
    end

    it 'returns the values from that file' do
      Lad::Config.load(@dir, @cfg)['a_property'].must_equal 'file_value'
    end
  end
end