require 'optparse'
require 'readline'

module Lad
  class Bootstrapper
    def self.execute
    
      optparser = OptionParser.new do |opts|
        opts.banner = '''
  Usage: lad [-h|--help] [<path_to_git_repo> <project_name>]

  Templated project token replacer/bootstrapper
        '''
        opts.on('-h', '--help', 'Displays this screen') do |v|
          puts opts
          exit
        end
      end

      optparser.parse!

      files_processed = 0
      dirs_processed  = 0
      options         = Arguments.extract
      dir             = File.join(Dir.tmpdir, options[:name])
      config          = {}

      puts '' # insert new line padding

      Console.task 'Cloning git repository' do
        Files.delete_temporary_files(dir)
        Files.clone_and_orphan(options[:git_url], dir)
      end
      
      Console.task 'Loading configuration' do
        config = Config.load dir, {
          'token'  => '__NAME__'
        }
      end

      Console.task 'Parsing tokens and stuff' do
        puts ''
        config['token_values'] = Config.get_token_values config, options[:name]
        puts ''
      end

      Console.task 'Processing files' do
        Dir.glob(File.join dir, '**/*').each do |item|
          if !File.directory?(item)
            files_processed += 1  

            config['token_values'].each do |token|
              new_item = Files.new_filename item, *token
              if item != new_item
                File.rename item, new_item 
                item = new_item
              end
              
              Files.replace_token_in_file config['ignore'], new_item, *token         
            end
          end
        end
      end

      Console.task 'Processing directories' do
        Dir.glob(File.join dir, '**/*').each do |item|
          if File.directory?(item)
            dirs_processed += 1
            config['token_values'].each do |token|
              new_item = Files.new_filename item, *token
              if item != new_item
                File.rename item, new_item
                item = new_item
              end   
            end
          end
        end
      end

      target_dir = File.join Dir.pwd, options[:name]
      Console.task 'Moving project files' do
        File.rename dir, target_dir
      end

      tasks = config['tasks']
      if !tasks.nil?
        Console.task 'Executing tasks' do
          Dir.chdir target_dir # go to target directory

          tasks = [tasks] if tasks.class == String
          tasks.each { |cmd| system cmd }
        end
      end

      Console.success "\n  Done processing #{files_processed} file(s)"
      Console.success "  Done processing #{dirs_processed} directories(s)"
    end
  end
end
