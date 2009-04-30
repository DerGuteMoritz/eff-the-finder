class F::Result

  attr_reader :name, :url

  def initialize(name, url)
    @name, @url = name, url
  end

  def to_s
    name
  end

  alias inspect to_s

end
