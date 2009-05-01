require 'httparty'
require 'nokogiri'

class F::Finder

  include HTTParty

  def initialize(args)
    @args, @term = args, args.join(' ')
  end

  def run
    if @args.empty?
      puts description
    else
      prompt(find)
    end
  end

  protected

  def result(*args)
    F::Result.new(*args)
  end

  def prompt(results)
    F::Prompt.new(results)
  end

  def result_for(path, query)
    yield(Nokogiri(self.class.get(path, :query => query)), result = F::Result.new(self))
    return result
  end

end
