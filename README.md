ruboto-rackup
=============

Android Ruboto app mimicking 'rackup'. 

This app starts a ruby rack server at a configurable port, starting the rack application configured in /sdcard/jruby/config.ru.
Besides Ruboto's (moderate) stack limitations any application works as it does on a desktop.

Quick Start
-----------
Copy config.ru to /sdard/jruby and start the app. You'll see a screen where the port cn be configured. It is generally
safe to leave it at 9292, ruby rack's default port.
The demo config.ru mounts 2 rack applications, /c showing the content of RbConfig::CONFIG and /e showing the content 
of the rack 'env' parameter as it is available for any application.

Just for an illustration of how to do it, a WebView widget is opened right below the server control
and displays the content of ``http://127.0.0.1:<port>/c``.

