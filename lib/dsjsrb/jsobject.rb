module DSJSRB
class JSObject
  def initialize
    @hash = Hash.new
  end

  def set_attribute(attr_name, value)
    @hash[attr_name] = value
  end

  def get_attribute(attr_name)
    @hash[attr_name]
  end
end
end
