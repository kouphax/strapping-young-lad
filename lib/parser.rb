module Lad
  class Arguments
    def self.extract
      return {
        git_url: ARGV.first,
        name:    ARGV.last
      }      
    end
  end
end