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
      if exclusions.nil? || !exclusions.member?(File.extname file)
        begin
          contents = File.read(file).gsub!(token, name)
          File.open(file, 'w') { |f| 
            f.puts contents 
          }
        rescue
          # oh yeah great idea swallow exceptions! so binary files can't be parsed etc these
          # need to be excluded by the config.  Wait lets rethrow like a boss
          Console.error '  Looks like you are trying to token replace the contents of a binary. '
          Console.error '  Perhaps you need to exclude this in the .ladconfig file? '
          
          throw 'Attempting to modify binary file'
        end
      end
    end
  end
end