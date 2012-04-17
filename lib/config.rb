module Lad
  class Config
    def self.load(dir, default_config)
      config_file = File.join dir, '.ladconfig'
      if File.exists?(config_file)
        YAML.load_file config_file
      else
        default_config
      end
    end
  end
end