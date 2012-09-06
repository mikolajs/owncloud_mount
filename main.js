#!/usr/bin/env seed

Gtk = imports.gi.Gtk;
Gtk.init(Seed.argv);
GtkBuilder = imports.gtkbuilder;
GObject = imports.gi.GObject;

var UI_FILE = "owncloud_mount.glade";
var isMounted = false;

var builder = new Gtk.Builder();
builder.add_from_file(UI_FILE);
var window = builder.get_object("window");
print(window);
var button_mount = builder.get_object("button1");
var button_unmount = builder.get_object("button2");
var label_info = builder.get_object("label1");
var text_user = builder.get_object("entry1");
var text_password = builder.get_object("entry2");





button_unmount.signal.clicked.connect(function(b){
      if(isMounted){
        print("UNMOUNTED");
        isMounted = false;
    } 
});

button_mount.signal.clicked.connect(function (b){
    if(!isMounted) {
    print("MOUNTED");
    isMounted = true;
    }
});

window.show_all();


Gtk.main();


    

