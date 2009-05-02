class Object

  def try(method)
    send(method) unless nil?
  end

  def instance_exec(*args, &block)
    mname = "__instance_exec_#{Thread.current.object_id.abs}"
    class << self; self end.class_eval{ define_method(mname, &block) }
    begin
      ret = send(mname, *args)
    ensure
      class << self; self end.class_eval{ undef_method(mname) } rescue nil
    end
    ret
  end

end

class String

  def blank?
    self =~ /\A\s*\z/
  end

end

class NilClass

  def blank?
    true
  end

end
