require "yaml"
require "logger"
require "./appenders"

module YamlToTimeSpan
  def self.from_yaml(ctx : YAML::ParseContext, node : YAML::Nodes::Node) : Time::Span
    unless node.is_a?(YAML::Nodes::Scalar)
      node.raise "Expected scalar, not #{node.class}"
    end

    (node.value.to_f? || node.value.to_i).seconds
  end
end

record BatchConfig, size : Int32, interval : Time::Span do
  include YAML::Serializable

  @[YAML::Field(converter: YamlToTimeSpan)]
  getter interval : Time::Span

  def self.from_yaml(ctx : YAML::ParseContext, node : YAML::Nodes::Node) : BatchConfig
    BatchConfig.new(ctx, node)
  end
end

module YamlToAppender
  def self.from_yaml(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
    appender_config = Hash(String, String).new(ctx, node)
    case DiagnosticLogger::Config::AppenderClass.parse(appender_config["class"])
    when DiagnosticLogger::Config::AppenderClass::FileAppender
      path_to_file = appender_config["file"]
      DiagnosticLogger::FileAppender.new(path_to_file, "a")
    when DiagnosticLogger::Config::AppenderClass::ConsoleAppender
      DiagnosticLogger::DefaultAppender
    end.not_nil!
  end
end


class DiagnosticLogger
  ConfigNamespace = "logger"
  DefaultLevel    = ::Logger::Severity::INFO
  DefaultAppender = ConsoleAppender.new(1, blocking: (LibC.isatty(1)) == 0)
  DefaultPattern  = "%{date} | [%{level}] %{pid}>%{fiber}>%{logger} | %{msg}"

  record Config,
    level : ::Logger::Severity = DiagnosticLogger::DefaultLevel,
    batch_config : BatchConfig? = nil,
    appender : IO = DiagnosticLogger::DefaultAppender,
    pattern : String = DiagnosticLogger::DefaultPattern do
    enum AppenderClass
      ConsoleAppender
      FileAppender
    end
    include YAML::Serializable

    @[YAML::Field(key: "batch", converter: BatchConfig)]
    getter batch_config : BatchConfig?

    @[YAML::Field(converter: YamlToAppender)]
    getter appender : IO

    def self.load(config : String | IO) : Config
      yml = YAML.parse config
      logger_yml = yml.raw.nil? ? "" : yml[ConfigNamespace]?.to_yaml
      Config.from_yaml(logger_yml)
    end
  end
end
