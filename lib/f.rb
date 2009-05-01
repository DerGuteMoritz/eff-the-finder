require 'rubygems'
require 'pathname'

class F

  def help
    'This is Eff.'
  end

  def self.load(glob, base = Pathname.new(__FILE__).dirname.join('f'))
    Dir[Pathname.new(base).join(File.join(*Array(glob)))].each do |file|
      require file
    end
  end

  load '*.rb'
  load 'finder/*.rb'
  load [ENV['HOME'], '.f/*.rb']

  def initialize(args)
    eval(args)
  rescue Interrupt
    exit 1
  end

  protected

  def eval(args)
    if args.empty?
      puts help
    else
      finder_class_for(args.shift).new(args).run
    end
  end

  class UnknownFinderError < NameError
  end

  def finder_class_for(f)
    a = f.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    cs = F::Finder.constants.select { |c| c =~ /\A#{Regexp.escape(a)}/ }
    raise UnknownFinderError.new("Sorry, I don't know a finder named `#{f}'.") if cs.size.zero?
    raise UnknownFinderError.new("There is more than one possible match for `#{f}: #{cs.join(', ')}.") if cs.size > 1
    F::Finder.const_get(cs[0])
  rescue UnknownFinderError => e
    puts e
    exit 1
  end

end
