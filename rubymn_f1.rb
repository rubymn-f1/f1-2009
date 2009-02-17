require 'rubygems'
require 'sinatra'
require 'flickr_fu'
 
gem('twitter4r', '0.3.0')
require('twitter')

configure do
  Cache = {}      # Create a new cache
end
 
get '/' do
  twitter = Twitter::Client.new(:login => ENV['F1_TWITTER_ACCOUNT'], :password => ENV['F1_TWITTER_PASSWORD'])
  flickr = Flickr.new(:key => ENV['F1_FLICKR_KEY'], :secret => ENV['F1_FLICKR_SECRET'])
  
  @flickr_tag = 'f1-web-challenge'
  @title = "f1.ruby.mn | Team 'ruby.mn' | F1 Overnight Website Challenge"
 
  @photos = flickr.photos.search(:tags => @flickr_tag, :per_page => 20, :page => 1)
  @friends_timeline = twitter.timeline_for(:friends)
  @friends = twitter.my(:friends)
 
  # Cache['index'] ||= erb :index
  erb :index
end

get '/clear' do
  Cache.clear
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
 <style type="text/css">
   body {
       margin-top: 2%;
       margin-left: 20%;
       margin-right: 20%;
       padding: 5px;
       text-align: center;
       background-color: #660000;
       font-family: helvetica,arial,clean,sans-serif;
   }
   div#wrapper {
      margin: 1em auto;
      width: 80%;
      border: 10px solid #8B0000;
      padding: 1em;
      background-color: #fff;
      text-align: left;
   }
   div#wrapper .logo {
     float: left;
     height: 100px;
     margin-right: 25px;
   }
   div#wrapper ul#nav-menu {
     list-style-type: none;
   }
   div#wrapper ul#nav-menu li {
     display:inline;
     padding: 5px;
   }
   div#wrapper li {
     margin-top: .5em;
   }
   div#members ul {
     list-style-type: none;
   }
   div#header {
     height: 120px;
   }
   div#members ul li {
     height: 40px;
     padding-bottom: 20px;
     border-bottom: 1px solid lightgray;
   }
   div#members img {
     vertical-align:middle;
     padding: 0 15px 0 0;
     float: left;
   }
   div#sponsors ul {
     list-style-type: none;
   }
   div#sponsors img {
     border: none;
   }
   div#table {
     padding: 5px;
   }
   div#statuses ul {
     list-style-type:none;
   }
   li.status {
     border-bottom: 1px solid lightgray;
     padding-bottom: 10px;
   }
   li.status img {
    vertical-align:middle;
    padding: 0 15px 0 0;
    float: left;
    height: 20px;
    border: none;
   }
   span.smaller {
     font-size: small;
     color:gray;
   }
 </style>
</head>
<body>
 <div id="wrapper">
   <div id='header'>
     <img src="/images/rubymn.gif" alt="<%= @title %>" title="<%= @title %>" class="logo"/>
      <h1 id="title">Team 'ruby.mn'</h1>
      <h4>Team activity stream for <a href='http://www.f1webchallenge.com/'>F1 Overnight Website Challenge</a> event</h4>
       <ul id="nav-menu">
         <li><a href="#statuses">Statuses</a></li>
         <li><a href="#photos">Photos</a></li>
         <li><a href="#members">Team Members</a></li>
         <li><a href="#links">Links</a></li>
         <li><a href="#sponsors">Visit our Sponsors!</a></li>
       </ul>
   </div>
    <%= yield %>
 </div>
</body>
</html>
 
@@ index
 
<div id="statuses">
  <h3>Twitter statuses</h3>
 <ul>
   <% for status in @friends_timeline %>
     <li class='status'><a href='<%=
 "http://twitter.com/#{status.user.screen_name}" %>'><img src="<%= status.user.profile_image_url %>" alt="<%= status.user.name %>" title="<%= status.user.name %>"/> <%=
 status.user.screen_name %></a>&nbsp;<%= status.text.gsub(/((https?:\/\/|www\.)([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?)/, %Q{<a href="\\1">\\1</a>}).gsub(/@(\w+)/, %Q{<a href="http://twitter.com/\\1">@\\1</a>}) %>&nbsp;
       <span class='smaller'><a href='<%= "http://twitter.com/#{status.user.screen_name}/statuses/#{status.id}"%>'><%= status.created_at.strftime("%m/%d/%Y") %></a></span>
     </li>
   <% end %>
 </ul>
</div>

<div id="photos">
  <h3>Flickr photos (public) tagged '<a href='<%= "http://flickr.com/photos/tags/#{@flickr_tag}" %>'><%= @flickr_tag %></a>'</h3>
  <% for photo in @photos %>
    <a href='<%= photo.url_photopage %>'><img src='<%= "#{photo.url(:square)}" %>' alt="<%= photo.title %>" title="<%= photo.title %>" /></a>
  <% end %>
</div>

<div id="members">
  <h3>Current Members on twitter</h3>
  <ul>
    <% for friend in @friends %>
      <li><img src="<%= friend.profile_image_url %>" alt="<%= friend.name %>" title="<%= friend.name %>"/>
        <a href='<%= "http://twitter.com/#{friend.screen_name}" %>'><%= friend.name %></a>
        <%= "<br/>Web: <a href='#{friend.url}'>#{friend.url}</a>" if friend.url %>
      </li>
    <% end %>
  </ul>
</div>

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

<div id="links">
  <h3>Links</h3>
  <ul>
    <li><a href="http://www.f1webchallenge.com/">Sierra Bravo's
  Overnight Website Challenge</a></li>
    <li><a
  href="http://www.f1webchallenge.com/teams/27-Ruby-mn-2-2">Team page on event web site</a></li>
    <li>Non-profit organization from 2008: <a href="http://www.littlebrothersmn.org/">Little Brothers of Minnesota</a></li>
    <li><a href="http://github.com/rubymn-f1">Team Ruby.mn on github</a></li>
  </ul>
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