module Lad
  require 'colorize'

  class Console
    def self.log msg
      puts msg
    end

    def self.warn msg
      puts msg.yellow
    end

    def self.error msg
      puts msg.red
    end

    def self.success msg
      puts msg.green
    end

    def self.task msg, &block
      print "  #{msg}".ljust(40)
      begin
        block.call
        puts "OK".green
      rescue Exception => e  
        puts "XX".red
        raise e
      end
    end
  end 
end