# danger-phpmd

[Danger](http://danger.systems/ruby/) plugin for [phpmd](https://phpmd.org/).

## Installation

    $ gem install danger-phpmd

## Usage

Add this to Dangerfile.

```
phpmd.run ruleset: "rulesets.xml"
```

If you want to specify phpmd bin file, you can set a bin path to the binary_path parameter.

```
phpmd.binary_path = "vendor/bin/phpmd"
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
    - uses: actions/checkout@v2
    - uses: ruby/setup-ruby@v1
      with:
        ruby-version: 2.6
        bundler-cache: true

    - name: Setup PHP environment
      uses: shivammathur/setup-php@v2
      with:
        php-version: '8.0'
        coverage: none
        tools: phpmd

    - run: bundle exec danger
      env:
        DANGER_GITHUB_API_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

