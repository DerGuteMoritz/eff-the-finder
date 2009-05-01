require 'delegate'

class F::Result < DelegateClass(Array)

  class PageError < StandardError
  end

  attr_accessor :header

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

  def self.url_from_anchor_attr(*names)
    names.each do |name|

      define_method "#{name}=" do |a|
        instance_variable_set "@#{name}", a[0]['href'] unless a.empty?
      end

      define_method name do
        instance_variable_get "@#{name}"
      end

    end
  end

  url_from_anchor_attr :next_url, :previous_url

  def initialize(finder)
    @finder = finder
    @items = []
    super(@items)
  end

  def <<(item)
    @items << Item.new(*item)
  end

  def page(p)
    attr = "#{p}_url"
    raise PageError if !respond_to?(attr) || send(attr).nil?
    @finder.find_by_url(send(attr))
  end

  def next_page
    page(:next)
  end

  def previous_page
    page(:previous)
  end

end
