# frozen_string_literal: true

require "json"
require "open3"

module Danger
  # [Danger](http://danger.systems/ruby/) plugin for [phpmd](https://phpmd.org/).
  #
  # @example Run phpmd and send warn comment.
  #
  #          phpmd.phpmd_path = "vendor/bin/phpmd"
  #          phpmd.config_path = "rulesets.xml"
  #          phpmd.run
  #
  # @see  ktakayama/danger-phpmd
  # @tags phpmd
  #
  class DangerPhpmd < Plugin
    # phpmd path
    # @return [String]
    attr_accessor :phpmd_path

    # phpmd.xml path
    # @return [String]
    attr_accessor :config_path

    # Execute phpmd
    # @return [void]
    def run
      return if target_files.empty?
      cmd = phpmd_path || "phpmd"
      json,e,s = Open3.capture3(cmd, target_files.join(","), "json", config_path)
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
      (git.added_files + (git.modified_files - git.deleted_files))
    end
  end
end
