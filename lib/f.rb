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
    exit
  end

  protected

  def eval(args)
    if args.empty?
      puts help
    else
      Finder.get(args.shift).run(args)
    end
  end

end
