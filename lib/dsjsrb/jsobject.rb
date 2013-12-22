module DSJSRB

module PrototypalEntity
  def remove_attribute(attr_name)
    self.class.class_eval do
      remove_method attr_name
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
end

class JSObject
  include PrototypalEntity
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
    define_attribute(attr_name, value)
  end
end

class JSScope
  include PrototypalEntity
  class << self
    alias :original_new :new
    def new
      Class.new(JSScope).original_new
    end

    def create(obj)
      Class.new(obj.class).original_new
    end
  end

  def set_attribute(attr_name, value)
    unless respond_to?(attr_name)
      # search maximal superclass
      klass = self.class
      while klass.superclass != JSScope
        klass = klass.superclass
      end
      klass.class_eval do
        define_method(attr_name) do
          value
        end
      end
    else
      method(attr_name).owner.class_eval do
        define_method(attr_name) do
          value
        end
      end
    end
  end

  def create_scope
    Class.new(self.class).original_new
  end
end

end
