# diagnostic_logger

Proof of concept for a thread-safe logger. This is an experimental shard and should not be used in production.

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
