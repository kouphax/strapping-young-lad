require 'minitest/autorun'
require 'tmpdir'

require './lib/files' # SUT

describe Lad::Files do
  describe 'resolving the new file name' do
    it 'replaces the token with the name in the filename only' do
      Lad::Files.new_filename(
        '/var/tmp/__NAME__/__NAME__.sln',
        '__NAME__',
        'Assertion').must_match '/var/tmp/__NAME__/Assertion.sln'
    end

    it 'will also replace tokens in the bottom most directory of a directory is passed' do
      Lad::Files.new_filename(
        '/var/tmp/__NAME__/__NAME__',
        '__NAME__',
        'Assertion').must_match '/var/tmp/__NAME__/Assertion'
    end

    it 'will disregard a trailing slash on directory token replacement' do
      Lad::Files.new_filename(
        '/var/tmp/__NAME__/__NAME__/',
        '__NAME__',
        'Assertion').must_match '/var/tmp/__NAME__/Assertion'
    end

    it 'will do nothing if the bottom most item hasn;t got the token' do
      Lad::Files.new_filename(
        '/var/tmp/__NAME__/__NAME__/Test.sln',
        '__NAME__',
        'Assertion').must_match '/var/tmp/__NAME__/__NAME__/Test.sln'
    end
  end

  describe 'replacing token in files' do

    before do
      @dir  = File.join Dir.tmpdir, (0..16).to_a.map{|a| rand(16).to_s(16)}.join
      @file = File.join @dir, 'targetfile.txt'
      @cfg  = {
        'a_property' => 'property_value'
      }

      FileUtils.rm_rf @dir if Dir.exists? @dir
      FileUtils.mkdir @dir

      @original = '''
        lorem lorem __NAME__ lorem lorem
        lorem __NAME__ lorem lorem lorem
      '''
      @expected = '''
        lorem lorem Assertion lorem lorem
        lorem Assertion lorem lorem lorem
      '''

      File.open(@file, 'w') { |f| f.puts @original }
    end

    after do
      FileUtils.rm_rf @dir
    end

    it 'will replace all instances of the token in a file' do
      Lad::Files.replace_token_in_file [], @file, '__NAME__', 'Assertion'
      File.open(@file).read.must_match @expected
    end

    it 'will not replace any tokens if the files extension is excluded' do
      Lad::Files.replace_token_in_file ['.txt'], @file, '__NAME__', 'Assertion'
      File.open(@file).read.must_match @original
    end
  end
end
