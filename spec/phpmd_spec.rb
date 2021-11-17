# frozen_string_literal: true

require File.expand_path("spec_helper", __dir__)

module Danger
  describe Danger::DangerPhpmd do
    it "should be a plugin" do
      expect(Danger::DangerPhpmd.new(nil)).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.phpmd
      end

      context "with a file included no warnings" do
        before do
          allow(@my_plugin).to receive(:target_files).and_return(
            [File.expand_path("fixtures/no_warnings.php", __dir__)]
          )
        end

        it "warns nothing" do
          @my_plugin.run({ ruleset: "cleancode" })

          expect(@dangerfile.status_report[:warnings]).to eq([])
        end
      end

      context "with a file included some warnings" do
        let(:expected_message) { "The method bar uses an else expression. Else clauses are basically not necessary and you can simplify the code by not using them." }
        before do
          allow(@my_plugin).to receive(:target_files).and_return(
            [File.expand_path("fixtures/cleancode_warnings.php", __dir__)]
          )
        end

        it "warns nothing" do
          @my_plugin.run({ ruleset: "cleancode" })

          expect(@dangerfile.status_report[:warnings]).to eq([expected_message])

          violation_report = @dangerfile.violation_report[:warnings].first
          expect(violation_report.file).to eq("spec/fixtures/cleancode_warnings.php")
          expect(violation_report.line).to eq(7)
          expect(violation_report.message).to eq(expected_message)
        end
      end
    end
  end
end
