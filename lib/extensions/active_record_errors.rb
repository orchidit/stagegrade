module ActiveRecord
  module Extensions
    def error_list
      return "" if self.errors.nil?
      "There were errors creating the #{self.class.to_s.singularize.humanize.downcase}:<ul>" + 
            self.errors.full_messages.map { |e| "<li>" + e + "</li>" }.join("\n") + "</ul>"
    end
  end
end

class ActiveRecord::Errors
  def for(attr)
    @errors[attr.to_s]
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Extensions)
