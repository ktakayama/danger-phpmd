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




