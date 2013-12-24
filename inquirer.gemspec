# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'inquirer/version'

spec = Gem::Specification.new do |s|
  s.name = 'inquirer'
  s.licenses = ['Apache v2']
  s.version = Inquirer::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = "Interactive user prompts on CLI for ruby."
  s.description = s.summary
  s.author = "Dominik Richter"
  s.email = "dominik.richter@googlemail.com"
  s.homepage = 'https://github.com/arlimus/inquirer.rb'

  s.add_dependency 'term-ansicolor', '>= 1.2.2'
  if( RUBY_ENGINE == "rbx" )
    s.add_dependency 'rubysl-mutex_m'
    s.add_dependency 'rubysl-singleton'
    s.add_dependency 'rubysl-io-console'
  end

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
