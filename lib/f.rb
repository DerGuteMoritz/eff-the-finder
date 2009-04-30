require 'rubygems'
require 'pathname'
require 'activesupport'

class F

  def help
    <<-end
This is Eff.
    end
  end

  def self.load(glob)
    Dir[Pathname.new(__FILE__).dirname.join('f').join(glob)].each do |file|
      require file
    end
  end

  load 'finder'
  load 'finder/*.rb'

  def initialize(args, out = $stdout)
    @out = out
    eval(args)
  end

  def eval(args)
    if args.size == 0
      puts help
    else
      finder = args.shift
      puts F::Finder.const_get(finder.camelize).new(args).run
    end
  rescue NameError => e
    raise unless e.message =~ /constant/
    puts "Sorry, I don't know a finder named `#{finder}'."
    exit 1
  end

  def puts(s)
    @out.puts(s)
  end

end
