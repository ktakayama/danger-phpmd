# danger-phpmd

[Danger](http://danger.systems/ruby/) plugin for [phpmd](https://phpmd.org/).

## Installation

    $ gem install danger-phpmd

`phpmd` also needs to be installed before you run Danger.
Please check the [installation guide](https://phpmd.org/download/index.html).

## Usage

Add this to Dangerfile.

```ruby
phpmd.run
```

PHPMD 3 automatically detects a configuration file (`phpmd.yml`, `phpmd.xml`, etc.) in the current directory.
If you want to specify rulesets, pass them to the `ruleset` option. Multiple rulesets can be separated by comma.

```ruby
phpmd.run ruleset: "phpmd.yml"
phpmd.run ruleset: "cleancode,codesize"
```

If you want to specify phpmd bin file, you can set a bin path to the binary_path parameter.

```ruby
phpmd.binary_path = "vendor/bin/phpmd"
phpmd.run
```

If phpmd fails (e.g. invalid ruleset), an error is raised with the output of phpmd.

### PHPMD 2

PHPMD 2 is also supported. The version is detected automatically.
The `ruleset` option is required for PHPMD 2.

```ruby
phpmd.run ruleset: "rulesets.xml"
```

### GitHub actions

```yaml
name: CI

on: [pull_request]

jobs:
  danger:
    runs-on: ubuntu-latest
    if: github.event_name  == 'pull_request'
    steps:
    - uses: actions/checkout@v6
    - uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.4
        bundler-cache: true

    - name: Setup PHP environment
      uses: shivammathur/setup-php@v2
      with:
        php-version: '8.4'
        coverage: none
        tools: phpmd:3

    - run: bundle exec danger
      env:
        DANGER_GITHUB_API_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
