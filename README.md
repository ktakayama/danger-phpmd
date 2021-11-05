# danger-phpmd

[Danger](http://danger.systems/ruby/) plugin for [phpmd](https://phpmd.org/).

## Installation

    $ gem install danger-phpmd

## Usage

<blockquote>Run phpmd and send warn comment.
<pre>
phpmd.phpmd_path = "vendor/bin/phpmd"
phpmd.config_path = "rulesets.xml"
phpmd.run
</pre>
</blockquote>



