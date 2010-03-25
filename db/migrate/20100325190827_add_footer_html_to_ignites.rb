class AddFooterHtmlToIgnites < ActiveRecord::Migration
  def self.up
    add_column :ignites, :footer_html, :text

    baltimore_ga_code = <<JS
<script type="text/javascript">
  //<![CDATA[
  var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
  document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
  try {
    var pageTracker = _gat._getTracker("UA-9222451-1");
    pageTracker._trackPageview();
  } catch(err) {}
  //]]>
</script>
JS
    railsconf_ga_code = <<JS
<script type="text/javascript">
  var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
  document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
  try {
    var pageTracker = _gat._getTracker("UA-15327626-1");
    pageTracker._trackPageview();
  } catch(err) {}</script>
JS
    
    run("UPDATE ignites SET footer_html = #{quote(baltimore_ga_code)} WHERE id = 1")
    run("UPDATE ignites SET footer_html = #{quote(railsconf_ga_code)} WHERE id = 4")
  end

  def self.down
    remove_column :ignites, :footer_html
  end
  
  def self.run sql
    connection.execute(sql)
  end
end
