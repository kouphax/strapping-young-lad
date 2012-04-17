module Lad
  class Files
    def self.new_filename(item, token, name)
      item_dir  = File.dirname item
      item_name = File.basename(item).gsub(token, name)

      File.join item_dir, item_name
    end

    def self.delete_temporary_files(dir)
      FileUtils.rm_rf dir if Dir.exists? dir
    end

    def self.clone_and_orphan(url, dir)
      Git.clone url, dir
      FileUtils.rm_rf File.join(dir, '.git')
    end

    def self.replace_token_in_file(exclusions, file, token, name)
      if !exclusions.member?(File.extname file)
        contents = File.read(file).gsub!(token, name)
        File.open(file, 'w') { |f| 
          f.puts contents 
        }
      end
    end
  end
end