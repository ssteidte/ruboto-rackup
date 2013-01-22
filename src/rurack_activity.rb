# Ruboto Rack server app
#
# version 3.3.2
#
# sst, 2013-01-20


require 'ruboto/activity'
require 'ruboto/widget'
require "ruboto/util/stack"
require 'ruboto/util/toast'
require 'ruboto/service'

$exc_handler = proc do |t, e|
  android.util.Log.e "Ruboto", e.to_s
  e.stack_trace.each {|i| android.util.Log.e "Ruboto", i.to_s}
end


with_large_stack do
  ruboto_import_widgets :Button, :ToggleButton, :LinearLayout, :TextView, :EditText
  ruboto_import_widget :WebView, "android.webkit"

  require 'webrick/httpserver.rb' 
  require 'rack'

  class RurackActivity
    
    def self.wifi_connected?
      ip_address != "localhost"
    end

    def self.ip_address
      ip = 0  #getSystemService(android.content.Context::WIFI_SERVICE).connection_info.ip_address
      return "localhost" if ip == 0
      [0, 8, 16, 24].map{|n| ((ip >> n) & 0xff).to_s}.join(".")
    end


    def on_create(bundle)
      super
      set_title "Ruboto Rack Server"

      ll = linear_layout(:orientation=>:vertical) do
        srvcontrol = linear_layout(:orientation=>:horizontal) do
          @start_button = toggle_button(
    #          :default_style => R::attr::buttonStyleSmall,
            :checked => !!@server,
            :layout => {:width= => :wrap_content}, 
            :on_click_listener => (proc {toggle_server})
          )
          text_view :text=>" Port"
          @input_port = edit_text :single_line=>true, :text=>"9292"
          text_view :text=>'    '
          @status_text = text_view :text => "Waiting"
        end

        @wv = web_view  #(:initial_scale => 100)
      end

      @wv.settings.use_wide_view_port = true
      @wv.settings.java_script_enabled = true
      @wv.settings.built_in_zoom_controls = true
       
      #
      self.content_view = ll
    rescue
      puts "Error creating activity: #{$!}\n#{$!.backtrace.join("\n")}"
    end

    private
    
    def toggle_server
      puts "toggle_server: #{@input_port.text}, #{@start_button.checked.inspect}"
      if @start_button.checked
        # start server
        @input_port.enabled = false
        @status_text.text = "Starting"
        port = @input_port.text.to_s.to_i
        app, opts = Rack::Builder.parse_file('/sdcard/jruby/config.ru')
        @server = Rack::Server.new(
          :Host=>'localhost',
          :Port=>port,
          :environment=>'development',  #'deployment',
          :app=>app
        )
        @tserver = Thread.with_large_stack {
          java.lang.Thread.currentThread.setUncaughtExceptionHandler($exc_handler)
          @server.start
        }
        sleep 5
        @status_text.text = "Running"
        @wv.loadUrl("http://127.0.0.1:#{port}/c")
      else
        # stop server
        @input_port.enabled = true
        @status_text.text = "Stopping"
        begin
          @server.server.shutdown
        rescue
          puts "Error shutting down server: #{$!}\n#{$!.backtrace.join("\n")}"
        end
        @tserver.join(60)
        @server = nil
        @status_text.text = "Stopped"
      end
    end
  end

end # with_large_stack