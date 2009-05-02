require 'rubygems'
require 'pathname'

class F

  def help
    puts 'This is Eff.'
    puts
    puts 'Available finders:'
    puts Finder.summary
    puts
    puts "Give finder's name as first argument to use it."
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
