class Add404And500Pages < ActiveRecord::Migration
  def self.up
    @page404 = Page.find_by_slug("404")
    if @page404.nil?
      p = Page.new(:title => "Page Not Found", :slug => "404")
      p.body = <<-HTML
      <div class="prepend-3 span-18 last">
      	<h2>Page Not Found</h2>
      	<hr />
      	<div style="text-align:center; font-size:1.5em">
      		You have reached a page that does not exist.<br /><br />
      		To find a great show, here are a few places to start:<br />
      		<a href="/">Home</a><br />
      		<a href="/productions">ShowFinder</a>
      	</div>
      </div>
      HTML
    end
    
    @page500 = Page.find_by_slug("500")
    if @page500.nil?
      p = Page.new(:title => "Technical Difficulties", :slug => "500")
      p.body = <<-HTML
      <div class="prepend-3 span-18 last">
      	<h2>Technical Difficulties</h2>
      	<hr />
      	<div style="text-align:center; font-size:1.5em">
      		We are experiencing temporary technical difficulties. Our apologies!<br /><br />
      		First, please try reloading this page.<br />
      		If that doesn't work, please <a href="/contact.html">contact us</a> and we'll do our best to solve the problem.
      	</div>
      </div>
      HTML
    end
  end

  def self.down
  end
end
