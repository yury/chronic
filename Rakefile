# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'spec/rake/spectask'

require './lib/chronic.rb'

Hoe.spec 'chronic' do
	readme_file = File.expand_path(File.join('.', "README.rdoc"))

	rubyforge_name = 'chronic'
	summary = 'A natural language date parser'

	developer('Tom Preston-Werner','tom@rubyisawesome.com')
	developer('Colin Shea','colin@evaryont.me')

	description = paragraphs_of(readme_file, 2).join("\n\n")
	url = paragraphs_of(readme_file, 0).first.split(/\n/)[1..-1]
	changes = paragraphs_of('History.txt', 0..1).join("\n\n")

	need_tar = false
	extra_deps = []
	version = Chronic::VERSION
end

desc "Run all specs"
Spec::Rake::SpecTask.new do |t|
	t.spec_files = FileList["spec/**/*_spec.rb"].sort
	t.spec_opts = ["--options", "spec/spec.opts"]
end

desc "Run all specs and get coverage statistics"
Spec::Rake::SpecTask.new('coverage') do |t|
	t.spec_opts = ["--options", "spec/spec.opts"]
	t.spec_files = FileList["spec/**/*_spec.rb"].sort
	t.rcov_opts = ["--exclude", "spec", "--exclude", "gems"]
	t.rcov = true
end

# vim: syntax=ruby
