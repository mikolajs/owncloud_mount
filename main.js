#!/usr/bin/env seed

Gtk = imports.gi.Gtk;
GIO = imports.gi.Gio;
Gtk.init(Seed.argv);
GtkBuilder = imports.gtkbuilder;
GObject = imports.gi.GObject;

var UI_FILE = "owncloud_mount.glade";
var isMounted = false;

var builder = new Gtk.Builder();
builder.add_from_file(UI_FILE);
var window = builder.get_object("window");
window.signal.hide.connect(Gtk.main_quit);

var button = builder.get_object("button");
var label_info = builder.get_object("label1");
var text_server = builder.get_object("entry0");
var text_user = builder.get_object("entry1");
var text_password = builder.get_object("entry2");

function readSecretFile(){
	var input_file = GIO.file_new_for_path("/home/ms/.davfs2/secrets")
    var fstream = input_file.read();
    var dstream = new GIO.DataInputStream.c_new(fstream);
    var line = dstream.read_until("", 0);
    fstream.close();
	print(line);
	return line;
}

var secretEntryLine =  readSecretFile();

button.signal.clicked.connect(function(b){
      if(isMounted){
		
        print("UNMOUNTED");
        isMounted = false;
    } 
});


window.show_all();
Gtk.main();


    

