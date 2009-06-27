require File.expand_path(File.dirname(__FILE__)) + '/../../spec_helper'

describe Object, :p do
	it "prints things out" do
		old_stdout = $stdout.dup

		tempio = StringIO.new

		$stdout = tempio
		p "foo"
		$stdout = old_stdout

		tempio.string.should == "\"foo\"\n\n"
	end
end
