class ApplicationFormBuilder < ActionView::Helpers::FormBuilder
  def label(method, text = nil, options = {})
    text = method.to_s.humanize.titleize if text.nil?
    text[-3..-1] = "URL" if text.downcase.ends_with?("url")
    text[-2..-1] = "IP" if text.downcase.ends_with?("ip")
    @template.label(@object_name, method, text, objectify_options(options))
  end
end