require 'tmpdir'
require 'git'
require 'fileutils'

require './console'
require './parser'
require './config'
require './files'

module Lad
  class Bootstrapper
    def execute
      options         = Arguments.extract
      dir             = File.join(Dir.tmpdir, options[:name])
      config          = {}
      files_processed = 0
      dirs_processed  = 0

      puts '' # insert new line padding

      Console.task 'Cloning git repository' do
        Files.delete_temporary_files(dir)
        Files.clone_and_orphan(options[:git_url], dir)
      end
      
      Console.task 'Loading configuration' do
        config = Config.load dir, {
          ignore: [
            '.png', '.jpg', '.gif', '.cache', '.suo', 
            '.dll', '.zip', '.nupkg', '.pdb', '.exe'
          ]
        }
      end

      Console.task 'Processing files' do
        Dir.glob(File.join dir, '**/*').each do |item|
          if !File.directory?(item)
            files_processed += 1     
            new_item = Files.new_filename item, '__NAME__', options[:name] 
            File.rename(item, new_item) if item != new_item

            Files.replace_token_in_file config[:ignore], new_item, '__NAME__', options[:name]
          end
        end
      end

      Console.task 'Processing directories' do
        Dir.glob(File.join dir, '**/*').each do |item|
          if File.directory?(item)
            dirs_processed += 1
            new_item = Files.new_filename item, '__NAME__', options[:name] 
            File.rename(item, new_item) if item != new_item
          end
        end
      end

      Console.task 'Moving project files' do
        File.rename dir, File.join(Dir.pwd, options[:name])
      end

      Console.success "\n  Done processing #{files_processed} file(s)"
      Console.success "  Done processing #{dirs_processed} directories(s)"
    end
  end
end
