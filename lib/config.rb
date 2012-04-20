module Lad
  require 'yaml'
  class Config
    def self.load(dir, default_config)
      config_file = File.join dir, '.ladconfig'
      if File.exists?(config_file)
        YAML.load_file config_file
      else
        default_config
      end
    end

    def self.get_token_values(cfg, default_value)
      tokens = cfg['token']
      if(tokens.class == Array)
        Hash[*tokens.map {|token|
          formatted = token.match(/__(.*)__/)[1].downcase
          value = Readline.readline("    #{formatted}#{' (' + default_value + ')' if formatted == 'name' }: ", true)
          value = default_value if formatted == 'name' && value == ''
          [token, value]
        }.flatten]
      else
        { tokens => default_value }
      end
    end
  end
end