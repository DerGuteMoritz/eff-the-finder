require 'httparty'
require 'nokogiri'

class F::Finder

  include HTTParty

  def initialize(args)
    @terms = args
  end

  protected

  def doc(path, query)
    Nokogiri(self.class.get(path, :query => query))
  end

end
