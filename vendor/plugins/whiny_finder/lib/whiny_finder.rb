module ActiveRecord #:nodoc:
  # Adds a <tt>find!</tt> method to ActiveRecord::Base as well as <tt>find_by_#{field}!</tt>. Both
  # of these will raise <tt>ActiveRecord::RecordNotFound</tt> instead of returning nil if no
  # records are returned.
  class << Base
    # Performs a <tt>find(*args)</tt> but raises <tt>ActiveRecord::RecordNotFound</tt> 
    # if no records are returned.
    def find!(*args)
      f = find(*args)
      raise ActiveRecord::RecordNotFound if f.nil? or (f.is_a? Array and f.empty?)
      f
    end

  private
    # Catches <tt>find_by_#{field}!</tt> or <tt>find_all_by_#{field}!</tt>
    # requests and does a find with the Rails finder but returns an 
    # <tt>ActiveRecord::RecordNotFound</tt> error if nothing is returned.
    def method_missing_with_whiny(meth, *args, &block)
      meth = meth.to_s
      if meth =~ /find_(all_by|by)_([_a-zA-Z]\w*)!$/
        f = method_missing_without_whiny(meth.sub('!','').to_sym, *args, &block) 
        raise ActiveRecord::RecordNotFound if f.nil? or (f.is_a? Array and f.empty?)
        f
      else
        method_missing_without_whiny(meth, *args, &block)
      end
    end
    # TODO: alias_method_chain :method_missing, :whiny 
    alias_method :method_missing_without_whiny, :method_missing
    alias_method :method_missing, :method_missing_with_whiny
  end
end