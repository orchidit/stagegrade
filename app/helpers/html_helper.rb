module HtmlHelper
  def tr(*arguments)
    "<tr>\n" + arguments.map { |arg| "\t" + td(arg) }.join("\n") + "\n</tr>"
  end

  def td(inner, options = nil)
    content_tag(:td, inner, options)
  end

  def nbsp(count = 1)
    str = ""
    count.times{ str << "&nbsp;" }
    str
  end

  def dummy_image_tag(h = 100, w = 100, text = "")
    image_tag("http://dummyimage.com/#{h}x#{w}/000/fff.jpg&text=#{text}")
  end
end