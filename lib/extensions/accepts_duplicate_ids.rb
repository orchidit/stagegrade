module Duplicable
  def duplicate_ids
    nil
  end

  def simple_duplicate_ids(dupe_ids)
    assocs = self.class.reflect_on_all_associations
    assocs.each do |assoc|
      if assoc.macro != :belongs_to and assoc.options[:through].nil?
        fk = assoc.options[:foreign_key] || self.class.to_s.downcase + "_id"
        assoc.klass.update_all({fk.to_sym => self.id}, {fk.to_sym => dupe_array(dupe_ids)})
      end
    end
  end

  def complex_duplicate_ids(dupe_ids)
    assocs = self.class.reflect_on_all_associations
    assocs.each do |assoc|
      if assoc.macro != :belongs_to and options[:through].nil?
        fk = options[:foreign_key] || self.class.to_s.downcase + "_id"
        objs = assoc.klass.find(dupe_array(dupe_ids))
        objs.each do |obj|
          obj.send((fk + "=").to_sym, self.id)
          obj.save(false)
        end
      end
    end
  end

  def duplicate_ids=(dupe_ids)
    return if dupe_ids.nil? or dupe_ids.empty?
    if self.class.accepts_duplicate_id_options[:simple].nil?
      complex_duplicate_ids(dupe_ids)
    elsif self.class.accepts_duplicate_id_options[:simple] == true
      simple_duplicate_ids(dupe_ids)
    end
  end

  def dupe_array(dupe_ids)
    array = []
    if dupe_ids.is_a? String
      array = dupe_ids.gsub(" ", "").split(",").map { |i| i.to_i }
    elsif dupe_ids.is_a? Array
      array = dupe_ids
    end
    array
  end
end

module DuplicableClassMethods
end

class ActiveRecord::Base
  @@opts = nil

  def self.accepts_duplicate_ids(options = {})
    @@opts = options
    extend DuplicableClassMethods
    include Duplicable
  end

  def self.accepts_duplicate_id_options
    @@opts
  end
end