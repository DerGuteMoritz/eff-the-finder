class Object

  def try(method)
    send(method) unless nil?
  end

end
