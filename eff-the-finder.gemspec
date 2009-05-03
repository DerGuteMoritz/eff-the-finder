# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{eff-the-finder}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Moritz Heidkamp"]
  s.date = %q{2009-05-03}
  s.default_executable = %q{f}
  s.description = %q{FIX (describe your package)}
  s.email = ["moritz@twoticketsplease.de"]
  s.executables = ["f"]
  s.extra_rdoc_files = ["History.txt", "README.rdoc"]
  s.files = ["History.txt", "README.rdoc", "Rakefile", "bin/f", "lib/f.rb", "lib/f/ext.rb", "lib/f/finder.rb", "lib/f/finder/google.rb", "lib/f/finder/imdb.rb", "lib/f/finder/piratebay.rb", "lib/f/finder/shoutcast.rb", "lib/f/finder/youtube.rb", "lib/f/prompt.rb", "lib/f/result.rb"]
  s.has_rdoc = true
  s.homepage = %q{  http://github.com/DerGuteMoritz/eff-the-finder/}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{eff}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{FIX (describe your package)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 0"])
      s.add_runtime_dependency(%q<mechanize>, [">= 0"])
      s.add_runtime_dependency(%q<launchy>, [">= 0"])
      s.add_development_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<highline>, [">= 0"])
      s.add_dependency(%q<mechanize>, [">= 0"])
      s.add_dependency(%q<launchy>, [">= 0"])
      s.add_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<highline>, [">= 0"])
    s.add_dependency(%q<mechanize>, [">= 0"])
    s.add_dependency(%q<launchy>, [">= 0"])
    s.add_dependency(%q<newgem>, [">= 1.4.1"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
