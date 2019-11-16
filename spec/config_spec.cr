require "./spec_helper"

describe Config do
  it "supports File appenders" do
    appender = Config.load_appender("logger:\n  appender:\n    class: FileAppender\n    file: logs")
    appender.should be_a(FileAppender)
  end

  it "supports Console appenders" do
    appender = Config.load_appender("logger:\n  appender:\n    class: ConsoleAppender")
    appender.should be_a(ConsoleAppender)
  end

  it "raises an exception if the appender class is unknown" do
    expect_raises(Config::UnknownAppender, /[Uu]nknown/) do
      appender = Config.load_appender("logger:\n  appender:\n    class: UnknownAppender")
    end
  end
end
