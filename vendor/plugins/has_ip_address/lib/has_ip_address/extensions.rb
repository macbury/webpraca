IPAddr.class_eval do
  # hack so == doesn't blow up when passed false
  def ==(other)
    return false if other.kind_of?(TrueClass) || other.kind_of?(FalseClass)

    # copied from original IPAddr#==
    if other.kind_of?(IPAddr) && @family != other.family
      return false
    end
    return (@addr == other.to_i)
  end
    
  def to_ipaddr
    self
  end
end

class Bignum
  def to_ipaddr
    IPAddr.new(self, Socket::AF_INET)
  end
end

class Fixnum
  def to_ipaddr
    IPAddr.new(self, Socket::AF_INET)
  end
end

class Object
  def to_ipaddr
    IPAddr.new(self)
  end
end
