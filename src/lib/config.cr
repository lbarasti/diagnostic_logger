require "yaml"
require "logger"
require "./file_appender"

module Config
  ConfigFile = "config.yml" # point at top-level configuration file
  def self.load_appender(config : String = File.read(ConfigFile))
    data = YAML.parse config
    log_filepath = data["logger"]["appender"]["file"].as_s
    FileAppender.new(log_filepath, "a")
  end

  def self.load_level(config : String = File.read(ConfigFile))
    data = YAML.parse config
    Logger::Severity.parse(data["logger"]["level"].as_s)
  end
end
