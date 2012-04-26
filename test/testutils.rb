require 'minitest/autorun'
module TestUtils
  def prepare_files_and_folders
    @dir     = File.join Dir.tmpdir, (0..16).to_a.map{|a| rand(16).to_s(16)}.join
    @file    = File.join @dir, 'targetfile.txt'
    @cfgfile = File.join @dir, '.ladconfig'
    @cfg     = { 'a_property' => 'property_value' }

    FileUtils.rm_rf @dir if Dir.exists? @dir
    FileUtils.mkdir @dir
  end

  def clear_temp_files
    FileUtils.rm_rf @dir
  end
end