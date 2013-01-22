# encoding: UTF-8
#
# Rack server configuration
#
#

#map "/"  do 
#  run Rack::File.new("/sdcard/jruby/webroot")
#end

map "/c" do
  run Proc.new {|env|
    require 'rbconfig'
    resp = RbConfig::CONFIG.to_a.sort.collect {|k,v| "#{k}: #{v.inspect}\n"}
    [200, {"Content-Type"=>"text/plain"}, resp]
  }
end

map "/e" do
  run Proc.new {|env|
    resp = env.to_a.sort.collect {|k,v| "#{k}: #{v.inspect}\n"}
    [200, {"Content-Type"=>"text/plain"}, resp]
  }
end

