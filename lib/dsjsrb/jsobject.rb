module DSJSRB
class JSObject
  class << self
    alias :original_new :new
    def new
      Class.new(JSObject).original_new
    end

    def create(obj)
      Class.new(obj.class).original_new
    end
  end

  def set_attribute(attr_name, value)
    unless respond_to?(attr_name)
      define_attribute(attr_name, value)
    else
      method(attr_name).owner.class_eval do
        define_method(attr_name) do
          value
        end
      end
    end
  end

  def get_attribute(attr_name)
    send(attr_name)
  end

  def define_attribute(attr_name, value)
    self.class.class_eval do
      define_method(attr_name) do
        value
      end
    end
  end

  def create_scope
    Class.new(self.class).original_new
  end
end
end
