Gem::Specification.new do |s|
  s.name        = 'aasm_progressable'
  s.version     = '1.0.0'
  s.date        = '2013-12-29'
  s.summary     = "AASM Progressable"
  s.description = "Progress indicators for linear AASM workflows"
  s.authors     = ["Brendan MacDonell"]
  s.email       = 'brendan@macdonell.net'
  s.files       = Dir.glob("{app,lib}/**/*") + %w(README.md)
  s.homepage    = 'http://rubygems.org/gems/aasm_progressable'
  s.license     = 'MIT'

  s.add_runtime_dependency 'rails', ['~> 4.0']
  s.add_runtime_dependency 'aasm', ['~> 3.0']
  s.add_runtime_dependency 'sass-rails', ['~> 4.0']
end
