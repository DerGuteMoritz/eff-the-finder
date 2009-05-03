require 'rubygems'
require 'pathname'

class F

  VERSION = '0.0.1'

  def help
    puts 'Eff The Finder'
    puts
    puts Finder.summary
    puts
    puts "Give a finder's name (initial letters suffice) as first argument to use it."
  end

  class << self

    def load(glob, base = Pathname.new(__FILE__).dirname.join('f'))
      Dir[Pathname.new(base).join(File.join(*Array(glob)))].each do |file|
        require file
      end
    end

    def rcload(glob)
      load ['.f/', glob], ENV['HOME']
    end

  end

  load '*.rb'
  load 'finder/*.rb'
  rcload '*.rb'

  def initialize(args)
    eval(args)
  rescue Interrupt
    exit
  end

  protected

  def eval(args)
    if args.empty?
      help
    else
      Finder.get(args.shift).run(args)
    end
  end

end
