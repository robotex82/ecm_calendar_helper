$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ecm/calendar_helper/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ecm_calendar_helper"
  s.version     = Ecm::CalendarHelper::VERSION
  s.authors     = ["Roberto Vasquez Angel"]
  s.email       = ["roberto@vasquez-angel.de"]
  s.homepage    = "https://github.com/robotex82/ecm_calendar_helper.git"
  s.summary     = "Rails calendar helper."
  s.description = "Rails calendar helper."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.6"

  s.add_development_dependency "sqlite3"
end
