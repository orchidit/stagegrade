module ExternalSnippetsHelper
  def google_search
    html = <<-HTML
    <form action="http://www.google.com/cse" id="cse-search-box">
      <div>
        <input type="hidden" name="cx" value="partner-pub-7405741267498883:xdutlavblb9" />
        <input type="hidden" name="ie" value="ISO-8859-1" />
        <input type="text" name="q" size="35" />
        <input type="submit" name="sa" value="Search StageGrade" />
      </div>
    </form>
    <script type="text/javascript" src="http://www.google.com/cse/brand?form=cse-search-box&amp;lang=en"></script>
    HTML
  end

  def google_ad_wide
    js = <<-HTML
      <script type="text/javascript"><!--
      google_ad_client = "pub-7405741267498883";
      /* 728x90, created 7/21/10 */
      google_ad_slot = "0625325976";
      google_ad_width = 728;
      google_ad_height = 90;
      //-->
      </script>
      <script type="text/javascript"
      src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
      </script>
    HTML

    RAILS_ENV == "production" ? js : dummy_image_tag(728, 90, "Ad")
  end

  def ad_square
    r = rand(10)
    r < 0 ? paperg_ad_square : google_ad_square
  end

  def google_ad_square
    js = <<-HTML
      <script type="text/javascript"><!--
      google_ad_client = "pub-7405741267498883";
      /* 200x200, created 7/21/10 */
      google_ad_slot = "2985725106";
      google_ad_width = 200;
      google_ad_height = 200;
      //-->
      </script>
      <script type="text/javascript"
      src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
      </script>
    HTML

    RAILS_ENV == "production" ? js : dummy_image_tag(200, 200, "Ad")
  end

  def paperg_ad_square
    js = <<-HTML
      <script type="text/javascript" src="http://www.paperg.com/jsfb/embed.php?pid=9062&bid=2711"></script><br />
      <div id="PG_link" align="center"><a href="http://www.paperg.com/">Local advertising</a> by PaperG</div>
    HTML

    RAILS_ENV == "production" ? js : dummy_image_tag(200, 200, "Ad")
  end

  def ad_tall
    r = rand(10)
    r < 0 ? paperg_ad_tall : google_ad_tall
  end

  def google_ad_tall
    js = <<-HTML
      <script type="text/javascript"><!--
      google_ad_client = "pub-7405741267498883";
      /* Home page right (160x600, created 2/23/10) */
      google_ad_slot = "7481594463";
      google_ad_width = 160;
      google_ad_height = 600;
      //-->
      </script>
      <script type="text/javascript"
      src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
      </script>
    HTML

    RAILS_ENV == "production" ? js : dummy_image_tag(160, 600, "Ad")
  end

  def paperg_ad_tall
    js = <<-HTML
      <script type="text/javascript" src="http://www.paperg.com/jsfb/embed.php?pid=9062&bid=2597"></script>
      <br /><div id="PG_link" align="center"><a href="http://www.paperg.com/">Local advertising</a> by PaperG</div>
    HTML

    RAILS_ENV == "production" ? js : dummy_image_tag(160, 600, "Ad")
  end

  def fb_like(url)
    html = <<-HTML
      <iframe id="fb-like-button" src="http://www.facebook.com/plugins/like.php?href=#{CGI.escape(url)}&amp;layout=button_count&amp;show_faces=true&amp;width=90&amp;action=recommend&amp;font=lucida+grande&amp;colorscheme=light&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:95px; height:21px; margin-bottom:-1px" allowTransparency="true"></iframe>
    HTML
    html
  end

  def twitter_share
    html = <<-HTML
      <a href="http://twitter.com/share" class="twitter-share-button" data-count="horizontal" data-via="stagegrade">Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>
    HTML
    html
  end

  def include_analytics
    js = <<-HTML
      <script type="text/javascript">
      var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
      document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
      </script>
      <script type="text/javascript">
      try {
        var pageTracker = _gat._getTracker("UA-12863507-1");
        pageTracker._trackPageview();
      } catch(err) {}</script>
      <!-- Start Quantcast tag -->
      <script type="text/javascript">
      _qoptions={
      qacct:"p-fcVBfeer1cOZk"
      };
      </script>
      <script type="text/javascript" src="http://edge.quantserve.com/quant.js"></script>
      <noscript>
      <img src="http://pixel.quantserve.com/pixel/p-fcVBfeer1cOZk.gif" style="display: none;" border="0" height="1" width="1" alt="Quantcast"/>
      </noscript>
      <!-- End Quantcast tag -->
    HTML
    RAILS_ENV == "production" ? js : ""
  end

  def include_markitup(*args)
    content_for :head do
      javascript_include_tag("markitup/jquery.markitup.pack") +
      javascript_include_tag("markitup/sets/default/set") +
      stylesheet_link_tag("markitup/sets/default/style") +
      stylesheet_link_tag("markitup/skins/simple-sg/style")
    end

    js = "$(document).ready(function() {\n"
    args.each { |arg| js += "$('#{arg}').markItUp(mySettings);\n" }
    js += "});"
    javascript_tag { js }
  end
end