# frozen_string_literal: true

require "json"
require "open3"

module Danger
  # [Danger](http://danger.systems/ruby/) plugin for [phpmd](https://phpmd.org/).
  #
  # @example Run phpmd and send warn comment.
  #
  #          phpmd.binary_path = "vendor/bin/phpmd"
  #          phpmd.run ruleset: "rulesets.xml"
  #
  # @see  ktakayama/danger-phpmd
  # @tags phpmd
  #
  class DangerPhpmd < Plugin
    # phpmd path
    # @return [String]
    attr_accessor :binary_path

    # Execute phpmd
    # @return [void]
    def run(options = {})
      return if target_files.empty?

      tmpfile = Tempfile.open("phpmd_result")
      _stdout, stderr, status = Open3.capture3(*command(tmpfile.path, options[:ruleset]))
      raise "phpmd failed: #{stderr}" unless [0, 2].include?(status.exitstatus)

      results = parse(tmpfile.read)
      results.each do |result|
        warn(result[:message], file: result[:file], line: result[:line])
      end
    end

    private

    def command(report_path, ruleset)
      if major_version >= 3
        rulesets = ruleset.to_s.split(",").flat_map { |r| ["--ruleset", r] }
        [cmd_path, "analyze", "--format", "json", "--reportfile-json", report_path, "--no-progress", *rulesets, "--", *target_files]
      else
        [cmd_path, "--reportfile", report_path, target_files.join(","), "json", ruleset]
      end
    end

    def major_version
      stdout, _stderr, _status = Open3.capture3(cmd_path, "--version")
      match = stdout.match(/PHPMD (\d+)\./)
      match ? match[1].to_i : 3
    end

    def cmd_path
      return binary_path if binary_path

      File.exist?("./vendor/bin/phpmd") ? "./vendor/bin/phpmd" : "phpmd"
    end

    def parse(json)
      array = JSON.parse json
      return if array.empty?

      path = "#{Dir.pwd}/"

      results = []
      array["files"].each do |line|
        file = line["file"].sub(path, "")
        line["violations"].each do |violation|
          results << {
            message: violation["description"],
            file: file,
            line: violation["beginLine"]
          }
        end
      end
      results
    end

    def target_files
      ((git.added_files + (git.modified_files - git.deleted_files)) - git.renamed_files.map { |r| r[:before] } + git.renamed_files.map { |r| r[:after] }).uniq
    end
  end
end
