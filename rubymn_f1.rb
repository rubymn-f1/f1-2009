require 'rubygems'
require 'sinatra'
require 'flickr_fu' 
gem('twitter4r', '0.3.0')
require('twitter')
require 'lib/caching'

configure do
  APP_CONFIG = YAML.load_file("config/configuration.yml")
end

get '/' do  
  twitter = Twitter::Client.new(:login => APP_CONFIG['twitter']['account'], :password => APP_CONFIG['twitter']['password'])
  flickr = Flickr.new(:key => APP_CONFIG['flickr']['key'], :secret => APP_CONFIG['flickr']['secret'])
  
  @flickr_tag = 'f1-web-challenge'
  @title = "f1.ruby.mn | Team 'ruby.mn' | F1 Overnight Website Challenge"
 
  @photos = flickr.photos.search(:tags => @flickr_tag, :per_page => 29, :page => 1)
  @friends_timeline = twitter.timeline_for(:friends) rescue []
  @friends = twitter.my(:friends) rescue [] 
  cache(erb(:index))
end
 
use_in_file_templates!
 
__END__
 
@@ layout
 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 <link rel="shortcut icon" type="image/x-icon" href="/images/favicon.ico" />
 <meta name="description" content="<%= @title %>" />
 <meta name="keywords" content="ruby, rails, non-profit, overnight website challenge, #webchallege, flickr, twitter, competition, charity" />
 <title><%= @title %></title>
 <link rel="stylesheet" media="screen,projection" type="text/css" href="/stylesheets/f1.ruby.mn.css" />
 <link rel="stylesheet" media="screen,projection" type="text/css" href="/stylesheets/tipsy.css" />
 <script type='text/javascript' src='http://ajax.googleapis.com/ajax/libs/jquery/1.3.1/jquery.min.js'></script>
 <script type='text/javascript' src='/javascripts/jquery.tipsy.js'></script>
 <script type='text/javascript'>
  $(document).ready(function() {
    $('span#friends a.tipsy').tipsy({gravity: 'n', fade: true});
    $('a.tipsy').click(function() {
      return false;
    });
  });
 </script>
</head>
<body>
 <div id="wrapper">
   <div id='header'>
     <span class='logo'>
       <img src="/images/rubymn-f1-logo.gif" alt="<%= @title %>" title="<%= @title %>" />
     </span>
     <span class='logotext' id='friends'><% @friends.each do |f| %><a title="<img src='<%= f.profile_image_url %>' alt='<%= f.name %>' title='<%= f.name %>'/><br/><br/><%= f.name %><br/><%= f.url %><br/><%= f.description %>" href='#' class='tipsy'><img src="<%= f.profile_image_url %>" alt="<%= f.name %>"/></a><% end %></span>
   </div>
    <div><%= yield %></div>
 </div>
 
 <script type="text/javascript">
 var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
 document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
 </script>
 <script type="text/javascript">
 try {
 var pageTracker = _gat._getTracker("UA-7564990-1");
 pageTracker._trackPageview();
 } catch(err) {}</script>
</body>
</html>
 
@@ index
 
<div id="statuses">
  <h3><img src='/images/twitter.ico' style='border:none;'/>&nbsp;Latest tweets</h3>
 <ul>
   <% for status in @friends_timeline %>
      <li class='status'><a href='<%= "http://twitter.com/#{status.user.screen_name}" %>'><img src="<%= status.user.profile_image_url %>" alt="<%= status.user.name %>" title="<%= status.user.name %>"/> <%=
  status.user.screen_name %></a>&nbsp;<%= status.text.gsub(/((https?:\/\/|www\.)([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?)/, %Q{<a href="\\1">\\1</a>}).gsub(/@(\w+)/, %Q{<a href="http://twitter.com/\\1">@\\1</a>}) %>&nbsp;
        <span class='smaller'><a href='<%= "http://twitter.com/#{status.user.screen_name}/statuses/#{status.id}"%>'><%= status.created_at.strftime("%m/%d/%Y") %></a></span>
      </li>
    <% end %>
 </ul>
</div>

<div id="photos">
  <h3><img src='/images/flickr.ico' style='border:none;'/>&nbsp;Latest photos <a href='<%= "http://flickr.com/photos/tags/#{@flickr_tag}" %>'><%= "##{@flickr_tag}" %></a></h3>
  <% for photo in @photos %>
    <a href='<%= photo.url_photopage %>'><img src='<%= "#{photo.url(:square)}" %>' alt="<%= photo.title %>" title="<%= photo.title %>" /></a>
  <% end %>
</div>

<div id="links">
  <h3>Links</h3>
  <ul>
    <li><a href="http://www.f1webchallenge.com/">Sierra Bravo's
  Overnight Website Challenge</a></li>
    <li><a
  href="http://www.f1webchallenge.com/teams/27-Ruby-mn-2-2">Team page on event web site</a></li>
    <li>Non-profit organization from 2008: <a href="http://www.littlebrothersmn.org/">Little Brothers of Minnesota</a></li>
    <li><a href="http://github.com/rubymn-f1/f1-2009/tree/master">Souce code for this site available on github!</a></li>
  </ul>
  <div id="alumni">
    <h3>Alumni (2008)</h3>
    <ul>
      <li>Lars Klevan</li>
      <li><a
    href="http://graphickarma.com/">Alicia Weller</a></li>
      <li><a
      href="http://smokejumperit.com/">Robert Fischer</a></li>
    </ul>
  </div>
</div>

<div id="sponsors">
  <h3>Sponsors</h3>
  <ul>
    <li><a href="http://www.trms.com/"><img src="/images/TRMS_logo.png" width="400" alt="Tightrope Media Systems logo"/><p>Tightrope Media Systems: Digital Signage and Broadcast From Your Web Browser</p></a>
      <blockquote>Tightrope Media Systems has provided funding for team t-shirts, team
      website hosting, and non-profit website hosting on a virtual private
      server for 1 year.</blockquote>
    </li>
    <li><a href="http://github.com"><img src="/images/github_logo.png" width="300" alt="Github logo"/><p>Github: Secure source code hosting and collaborative development</p></a>
      <blockquote>GitHub is providing the Ruby.mn webchallenge team with a free account to host the private repositories of our non-profits.</blockquote>
    </li>
  </ul>
</div>

<p><a href="#title">Return to top</a></p>