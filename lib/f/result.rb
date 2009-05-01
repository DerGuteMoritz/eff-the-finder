require 'delegate'

class F::Result < DelegateClass(Array)

  class Item

    attr_reader :name, :url

    def initialize(name, url)
      @name, @url = name, url
    end

    def to_s
      name
    end

    alias inspect to_s

  end

  def initialize(finder)
    @finder = finder
    @items = []
    super(@items)
  end

  def <<(item)
    @items << Item.new(*item)
  end

end
