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


## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/diagnostic_logger/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [lorenzo.barasti](https://github.com/your-github-user) - creator and maintainer
