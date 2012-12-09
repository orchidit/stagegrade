# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  ActionView::Base.default_form_builder = ApplicationFormBuilder
  include HtmlHelper
  include JavascriptHelper
  include ExternalSnippetsHelper
  include PathHelper
  include DateHelper

  def strftime(time, format, nil_string = "")
    time.nil? ? nil_string : time.strftime(format)
  end

  # Inserts a menu with `header` using `method` as the query parameter name
  # Options can contain a hash with default params {:method => :value}, a custom menu ID and/or class.
  # Items contains an array of tuples representing the [key, text] of each item.
  def menu(method, header, items_and_options = {})
    items = items_and_options[:items] || []
    options = items_and_options[:options] || {}

    out = ""
    out += content_tag(:li, header, :class => "menu_title ui-state-default")
    first = ["menu_item_first"]

    items.each do |item|
      key, value = item[0], item[1]

      out += content_tag(:li, 
          link_to(value, current_request_path(method.to_sym => (key == :all ? nil : key))),
          :id => method.to_s + "-" + key.to_s, :class => first.shift)
    end

    js_layout_tabs((options[:default] || {}).merge({ :id => options[:id] })) + 
    content_tag(:div, :id => (options[:id] || "menu"), :class => options[:class]) do 
      content_tag(:ul, out)
    end
  end

  def menu_item(text, rels = {})
    kv = rels.to_query.split("=")
    kv << "" if kv.length == 1
    "<a class=\"new-menu-item\" href=\"" + current_request_path(rels) + "\" name=\"" + kv[0] + "\" rel=\"" + kv[1] + "\">" +
      text +
    "</a>"
  end

  def button(text, url, options = {})
    return remote_button(text, url, options) if options[:remote] == true

    css_classes = [ "button", options[:color], options[:selected] == true ? "selected" : nil ]
    link_to_options = { :class => css_classes.join(" ") }
    link_to_options[:id] = options[:id] unless options[:id].nil?

    if !options[:method].nil?
      link_to_options[:method] = options[:method]
      unless options[:suppress_confirm] == true
        link_to_options[:confirm] = options[:confirm].nil? ? "Are you sure?" : options[:confirm]
      end
    end
    link_to(text, url, link_to_options)
  end

  def remote_button(text, url, options = {})
    css_classes = [ "button", options[:color], options[:selected] == true ? "selected" : nil ]
    link_to_options = { :html => { :class => css_classes.join(" ") } }
    link_to_options[:url] = url
    link_to_options[:update] = options[:update] if !options[:update].nil?
    link_to_options[:loading] = options[:loading] if !options[:loading].nil?

    if !options[:method].nil?
      link_to_options[:method] = options[:method]
      unless options[:suppress_confirm] == true
        link_to_options[:confirm] = options[:confirm].nil? ? "Are you sure?" : options[:confirm]
      end
    end

    link_to_remote(text, link_to_options)
  end

  def yellow_button(text, url, options = {})
    options[:color] = "yellow"
    button(text, url, options)
  end

  def red_button(text, url, options = {})
    options[:color] = "red"
    button(text, url, options)
  end

  def green_button(text, url, options = {})
    options[:color] = "green"
    button(text, url, options)
  end

  def defined_or_value(var, value = nil)
    defined? var ? var : value
  end

  def admin_links(links = [], options = {})
    out = ""
    wrap_each = options[:wrap_each] || []

    links.each do |link|
      model = link[:model].nil? ? "" : link[:model].to_s
      this = ""
      if link[:action] == :new
        this += link_to "New #{model.titleize}", send("new_admin_" + model.to_s + "_path")
      elsif link[:action] == :index
        this += link_to pluralize(model.camelize.constantize.count, model.titleize), send("admin_" + model.pluralize + "_path")
      else
        this += link_to link[:text], link[:action]
      end
      out += wrap(this, wrap_each)
    end
    out
  end

  # Wraps the content with the given tags. Tags is a symbol, an array of tags (as symbols),
  # or an array of tuples, with each inner tuple containing the tag as the first element, and
  # the hash of options for content_tag as the second element.
  def wrap(content, tags)
    out = content
    return content_tag(tags, content) if tags.is_a? Symbol

    tags.reverse.each do |tag|
      tag = [tag].flatten
      out = content_tag(tag.shift, out, tag.shift)
    end
    out
  end

  # Source:
  # http://github.com/alloy/complex-form-examples/blob/master/app/helpers/projects_helper.rb
  #
  # This method demonstrates the use of the :child_index option to render a
  # form partial for, for instance, client side addition of new nested
  # records.
  #
  # This specific example creates a link which uses javascript to add a new
  # form partial to the DOM.
  #
  #   <% form_for @project do |project_form| -%>
  #     <div id="tasks">
  #       <% project_form.fields_for :tasks do |task_form| %>
  #         <%= render :partial => 'task', :locals => { :f => task_form } %>
  #       <% end %>
  #     </div>
  #   <% end -%>
  def generate_html(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f

    form_builder.fields_for(method, options[:object], :child_index => 'NEW_RECORD') do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
    end
  end

  def generate_template(form_builder, method, options = {})
    escape_javascript generate_html(form_builder, method, options)
  end
end
