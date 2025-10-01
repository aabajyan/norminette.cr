# norminette.cr

> **⚠️ This project is no longer maintained and will not work anymore. Please use the official Norminette at <https://github.com/42School/norminette> instead.**

Crystal implementation of the official 42 Norminette.

## Installation

```sh
git clone https://github.com/aabajyan/norminette.cr
cd norminette.cr
shards install
crystal build src/cli.cr -o norminette
alias norminette='/path/to/norminette.cr/norminette'
```

## Usage

```sh
norminette [paths, default: CURRENT_DIR] [-h|--help] [-v|--version]
```

## TODO

- [x] Add a way to use this as a library, for example return a JSON data once it's done.
- [ ] Add a way to check the files with specificied rules only.

## Contributing

1. Fork it (<https://github.com/aabajyan/norminette.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [aabajyan](https://github.com/aabajyan) - creator and maintainer
