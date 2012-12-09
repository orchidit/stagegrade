class Reviewer < ActiveRecord::Base
  self.abstract_class = true
  
  def self.find(*args)
    all = Array.new
    options = Hash.new
    
    if args.last.is_a?(Hash)
      options.merge!(args.last)
      args.last.delete(:show)

      unless options[:show].nil? or options[:show].is_a? String
        options[:show].map! { |o| o.to_sym }
      end
    end

    subtypes = nil
    if options[:show].nil? or options[:show].length == 0
      subtypes = [:critics, :publications]
    else
      subtypes = [options[:show]].flatten
    end
    
    subtypes.each { |subtype|
      all.concat(Kernel.const_get(subtype.to_s.singularize.capitalize).find(*args))
    }
    all
  end
  
  def self.sort(array, attr_name, nil_value, order = :asc)
    array.sort { |x,y| 
      if order.to_s.downcase == "asc"
        (x.send(attr_name) || nil_value) <=> (y.send(attr_name) || nil_value)
      elsif order.to_s.downcase == "desc"
        (y.send(attr_name) || nil_value) <=> (x.send(attr_name) || nil_value)
      end
    }
  end
  
end