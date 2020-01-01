[![GitHub release](https://img.shields.io/github/release/lbarasti/diagnostic_logger.svg)](https://github.com/lbarasti/diagnostic_logger/releases)
![Build Status](https://github.com/lbarasti/diagnostic_logger/workflows/Crystal%20CI/badge.svg)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

# diagnostic_logger

A thread-safe, configurable logger for the Crystal Language. This shard is still under active development, and has not been used at scale, yet.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     diagnostic_logger:
       github: lbarasti/diagnostic_logger
   ```

2. Run `shards install`

## Usage

```crystal
require "diagnostic_logger"

logger = DiagnosticLogger.new("my-component")
logger.info("hello world") # logs "2019-11-14 02:11:12 UTC [INFO] my-component:main> hello world"
```

## Configuring your logger

By default, `diagnostic_logger` uses the following configuration.
```
logger:
  level: INFO
  appender:
    class: ConsoleAppender
  pattern: "%{date} | [%{level}] %{pid}>%{fiber}>%{logger} | %{msg}"
```

To customise it, just create a `config.yml` file in the root folder of your project, and populate it with your overrides.

### level
`level` specifies the severity of the messages that should be logged. For example, setting `level` to `WARN` will suppress any log at `DEBUG` or `INFO` level.

Severities are defined by the [Crystal standard library](https://crystal-lang.org/api/0.32.1/Logger/Severity.html) as `DEBUG`, `INFO`, `WARN`, `ERROR`, `FATAL`, `UNKNOWN`.

Although `level` is set globally based on the configuration above, its value can be overridden programmatically when initialising a logger:
```crystal
logger = DiagnosticLogger.new("my-component", level: :warn)
logger.info("hello") # will not log
```

### appender
The `appender` determines the target IO for your logs, based on the `class` field.

`class` can take the following values:
* _ConsoleAppender_ (default): will log to `STDOUT`
* _FileAppender_: will log to a file specified in `file`

For example, to log to a file named `logs.txt`, your `config.yml` should include the following.
```
logger:
  appender:
    class: FileAppender
    file: logs.txt
```

### pattern
Basic template-based formatting is supported. You can interpolate the following keywords in a template string, wrapped in `%{}`.

* _date_: the timestamp of the message in UTC format - e.g. `2020-01-01 16:21:44 UTC`
* _level_: the severity of the message - e.g. `WARN`
* _logger_: the name of the `DiagnosticLogger` instance - set at initialisation time
* _fiber_: the name of the fiber logging the message
* _msg_: the actual content of the log
* _pid_: the Process ID of the process logging the message.

For example, to only log date, message and level, your config could look like the following:
```
logger:
  pattern: "%{date} [%{level}] %{msg}"
```

### batch
You can tune the frequency and size of log writes by specifying a batch `size` and `interval`, where

* _size_ is the number of messages to keep in memory before writing to IO
* _interval_ (in seconds) is the amount of time after which logged messagges will be written to IO, whenever the number of messages doesn't hit the specified _size_ in the current interval.

For example, to write to IO every 30 messages - or every 5 seconds, in case fewer than 30 messages were logged in the last 5 second interval - your `config.yml` should include the following.
```
logger:
  batch:
    size: 30
    interval: 5
```

## Development

Run `crystal spec` to run project's tests.
You can also manually run the examples under `/examples` - remember to `cd` into an example's folder before doing so, so that the right `config.yml` is picked up.

## Contributing

1. Fork it (<https://github.com/your-github-user/diagnostic_logger/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [lorenzo.barasti](https://github.com/your-github-user) - creator and maintainer
