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
    def run(options)
      return if target_files.empty?
      cmd = binary_path || "phpmd"
      json,e,s = Open3.capture3(cmd, target_files.join(","), "json", options[:ruleset])
      results = parse(json)
      results.each do |result|
        warn(result[:message], file: result[:file], line: result[:line])
      end
    end

    private

    def parse(json)
      array = JSON.parse json
      return if array.empty?
      path = "#{Dir.pwd}/"

      results = []
      array['files'].each do |line|
        file = line['file'].sub(path, "")
        line['violations'].each do |violation|
          results << {
            message: violation['description'],
            file: file,
            line: violation['beginLine']
          }
        end
      end
      results
    end

    def target_files
      ((git.added_files + (git.modified_files - git.deleted_files)) - git.renamed_files.map{|r|r[:before]} + git.renamed_files.map{|r|r[:after]}).uniq
    end
  end
end
