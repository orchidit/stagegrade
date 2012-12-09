class Object
  def add_ivar(name, val = nil)
    self.instance_eval <<-STR
      def #{name}=(v); @#{name} = v; end
      def #{name}; @#{name}; end
    STR
    self.send((name + "=").to_sym, val)
  end
end
