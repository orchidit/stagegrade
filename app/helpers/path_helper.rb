module PathHelper
  def current_request_path(addl_params = {})
    new_get = request.GET.merge(addl_params).delete_if { |k,v| v.nil? }.to_query

    if new_get == ""
      request.path
    else
      request.path + "?" + new_get
    end
  end

  def path_to_url(path)
    request.protocol + request.host_with_port + path
  end

  def admin_form_path(resource)
    klass = resource.class.to_s.downcase
    resource.new_record? ? send("admin_#{klass.pluralize}_path") : send("admin_#{klass}_path", resource)
  end

  def query_string_hash(more_params = {})
    kvs = request.query_string.split("&")
    hash = {}
    kvs.each do |kv|
      split = kv.split("=")
      hash[split[0]] = split[1]
    end

    hash.merge!(more_params)
    hash.each do |k,v|
      hash.delete(k) if v.nil? or v.empty?
    end
    hash
  end

  def query_string(more_params = {})
    str = "?"
    query_string_hash.each do |k,v|
      str += k + "=" + v + "&"
    end
    str[0..-2]
  end
end