module JavascriptHelper
  def jq_document_ready_tag(content, jq = "$")
    javascript_tag(jq + "(document).ready(function() {" + content + "})")
  end

  def js_layout_tabs(options = nil)
    javascript_tag "$(document).ready(function() {
      layoutTabs(#{options ? ActiveSupport::JSON.encode(options) : ""});
    });"
  end

  def gchart(selector, scores, labels = nil)
    labels ||= ["F", "D", "C", "B", "A"]
    grouped_grades = Grading.grouped_grades_for_scores(scores)

    js_labels = "[" + labels.map { |l| "'" + l +  "'" }.join(", ") + "]"
    js_values = "[" + labels.map { |l| grouped_grades[l] }.join(", ") + "]"
    js_selector = "'" + selector + "'"

    "<script type=\"text/javascript\">
      labels = #{js_labels};
      values = #{js_values};
      $(document).ready(function() { $(#{js_selector}).histogram(labels, values); });
    </script>"
  end
end