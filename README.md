ruboto-rackup
=============

Android Ruboto app mimicking 'rackup'. 

This is a Ruboto project, see http://ruboto.org for more information.

This app starts a ruby rack server at a configurable port, starting the rack application configured in /sdcard/jruby/config.ru.
Besides Ruboto's (moderate) stack limitations any applications work as they do on the desktop.
This holds true for plain ruby and stdlib code. Some libraries and gems might not yet be supported on Ruboto.

The advantage is, that you develop the rack application on the dektop and then just copy the file to
the device using the remote copy method of your choice. No recompile needed, just stop and start the server again
to pick up the changes.


Quick Start
-----------
Copy config.ru to /sdard/jruby and start the app. You'll see a screen where the port cn be configured. It is generally
safe to leave it at 9292, ruby rack's default port.
The demo config.ru mounts 2 rack applications, /c showing the content of RbConfig::CONFIG and /e showing the content 
of the rack 'env' parameter as it is available for any application.

Just for an illustration of how to do it, a WebView widget is opened right below the server control
and displays the content of ``http://127.0.0.1:<port>/c``.

Note
----
The target Android API level is 16. Edit project.properties and AndroidManifest.xml to change it.

