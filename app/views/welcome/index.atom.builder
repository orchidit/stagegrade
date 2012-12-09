atom_feed do |atom|
  atom.title("StageGrade")
  atom.updated(@feed_published_at)

  @feed.each do |post|
    atom.entry(post, :published => post.original_published_at) do |entry|
      if post.is_a? Production
        entry.title(post.play_title)
        if !post.teaser.nil?
          entry.content(post.teaser)
        else
          entry.content(
          "<div class=\"image\" style=\"text-align: center\">" +
            image_tag(path_to_url(post.photo.url), :width => "270px",
            :alt => "Photo from #{post.play_title}") + "<br />" +
          "</div>" +
          "<div class=\"text\">" +
            simple_format(truncate_html(post.editorial_summary, 300, "... " +
                link_to("(Read More)", production_url(post)))) +
          "</div>", :type => 'html')
        end
        entry.author { |author| author.name("StageGrade") }
      else
        entry.title(post.title)
        entry.content(simple_format(truncate_html(post.text, 300, "... " + 
            link_to("(Read More)", post_url(post)))), :type => 'html')
        entry.author { |author| author.name(post.user.name) }
      end
    end
  end
end