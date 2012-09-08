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
var label_info = builder.get_object("label");
var text_server = builder.get_object("entry0");
var text_user = builder.get_object("entry1");
var text_password = builder.get_object("entry2");

function getHomeDir(){
	var appCommand = new GIO.ApplicationCommandLine();
	return appCommand.getenv("HOME");
}

function readSecretFile(){
	var dirStr = getHomeDir() + "/.davfs2";
	var fileStr = "/secrets";
	var file = GIO.file_new_for_path(dirStr + fileStr);
	if(!file.query_exists()) { 
		var devDir = GIO.file_new_for_path(dirStr);
		if(!devDir.query_exists()) {
			devDir.make_directory();
		}
	}
	var input_file = GIO.file_new_for_path(dirStr + fileStr)
	if(!input_file.query_exists()) {
		input_file.create();
		return "";
	} 
	else {
		var fstream = input_file.read();
		var dstream = new GIO.DataInputStream.c_new(fstream);
		var line = dstream.read_until("", 0);
		fstream.close();
		print(line);
		return line; 
	}
}

var secretEntryLine =  readSecretFile();

print(getHomeDir());

button.signal.clicked.connect(function(b){
      if(isMounted){
		
        print("UNMOUNTED");
        isMounted = false;
    } 
});
GIO.file_new_for_path("/home/ms/javasrciptseedfile.txt");

window.show_all();
Gtk.main();


    

