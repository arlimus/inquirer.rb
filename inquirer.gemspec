# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'inquirer'

spec = Gem::Specification.new do |s|
  s.name = 'inquirer'
  s.licenses = ['MPLv2']
  s.version = Inquirer::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = "Interactive user prompts on CLI for ruby."
  s.description = s.summary
  s.author = "Dominik Richter"
  s.email = "dominik.richter@googlemail.com"
  s.homepage = 'https://github.com/arlimus/livecd'

  s.add_dependency 'term-ansicolor', '>= 1.2.2'
  s.add_dependency 'io-console', '>= 0.4.2'

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
