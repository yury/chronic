# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'spec/rake/spectask'

require './lib/chronic.rb'

Hoe.new('chronic', Chronic::VERSION) do |p|
  p.rubyforge_name = 'chronic'
  p.summary = 'A natural language date parser'
  p.author = 'Tom Preston-Werner'
  p.email = 'tom@rubyisawesome.com'
  p.description = p.paragraphs_of('README', 2).join("\n\n")
  p.url = p.paragraphs_of('README', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.need_tar = false
  p.extra_deps = []
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

# vim: syntax=Ruby
