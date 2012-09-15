/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*- 
 * Copyright (C) 2012 Mikołaj Sochacki <mikolajsochacki@gmail.com>
 * owncloud_mount licence: GPL v3
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using GLib;
using Gtk;
using Notify;

public class Main : Object 
{
	//const string UI_FILE = "owncloud_mount.ui";

	bool isMounted = false;
	private Label label_info;
	private Entry text_user;
	private Entry text_password;
	private Entry http_address;
	private Window window;
	private SecretFileAct secret;

	public Main ()
	{
		
		try 
		{
			var builder = new Builder ();
			builder.add_from_string (UI_CONTENT, UI_CONTENT.length);
			builder.connect_signals (this);

			window = builder.get_object ("window") as Window;
			window.destroy.connect (Gtk.main_quit);
			var button = builder.get_object ("button") as Button;
			button.clicked.connect(on_clicked_act);
		    label_info = builder.get_object ("label") as Label;
			http_address = builder.get_object ("entry0") as  Entry;
			text_user = builder.get_object ("entry1") as  Entry;
			text_password = builder.get_object ("entry2") as Entry;
			window.show_all ();
			var mountingMonitor = new Mounting();
			if(mountingMonitor.isMounted()){
				isMounted = true;
				button.label = "Odmontuj";
				this.label_info.label = "Owncloud jest zamontowany";
			}
			else {
				isMounted = false;
				button.label = "Zamontuj";
				this.label_info.label = "Owncloud nie jest zamontowany";
			}
			secret = new SecretFileAct();
			text_user.text = secret.getUserName();
			text_password.text = secret.getPassword();
			http_address.text = secret.getServerPath();
		} 
		catch (Error e) {
			stderr.printf ("Could not load UI: %s\n", e.message);
		} 

	}

	[CCode (instance_pos = -1)]
	public void on_destroy (Widget window) 
	{
		Gtk.main_quit();
	}

	private void on_clicked_act() {
		if(!isMounted) {
				string user = this.text_user.text;
				string pass =  this.text_password.text;
				string server = this.http_address.text;
				stdout.printf ("server: %s user: %s hasło: %s\n", server, user, pass);
				var mountingMonitor = new Mounting();
				secret.save(server, user, pass);
				if(mountingMonitor.mountDevice()) {					
						this.label_info.label = "Zamontowano";
						isMounted = true;
						secret.save(server, "", "");
						showNotify("Zamonotowano Owncloud");
						on_destroy(window);
				}
				else {
					this.label_info.label = "Błąd. Nie udało się zamontować";
					secret.save(server, "", "");
				}
		}
		else {
			string server = this.http_address.text;
			var mountingMonitor = new Mounting();
			if(mountingMonitor.unmountDevice())	{
				this.label_info.label = "Odmontowano";
				showNotify("Odmonotowano Owncloud");
				secret.save(server, "", "");
				on_destroy(window);
			}
			else {
				this.label_info.label = "Błąd. Nie udało się odmontować";
			}
		}
	}

	private void showNotify(string massage){
		Notify.init ("Owncloud");
		var Hello = new Notification("Owncloud", massage, "dialog-information");
		Hello.show ();
	}

	static int main (string[] args) 
	{
		Gtk.init (ref args);
		var app = new Main ();

		Gtk.main ();
		
		return 0;
	}

 const string UI_CONTENT = """
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <!-- interface-requires gtk+ 3.0 -->
  <object class="GtkWindow" id="window">
    <property name="visible">True</property>
    <property name="can_focus">False</property>
    <property name="valign">center</property>
    <property name="title" translatable="yes">Owncloud montowanie</property>
    <property name="default_width">470</property>
    <property name="default_height">190</property>
    <signal name="destroy" handler="main_on_destroy" swapped="no"/>
    <child>
      <object class="GtkBox" id="box1">
        <property name="visible">True</property>
        <property name="can_focus">False</property>
        <property name="orientation">vertical</property>
        <child>
          <object class="GtkGrid" id="grid1">
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <child>
              <object class="GtkLabel" id="label4">
                <property name="width_request">200</property>
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="xpad">48</property>
                <property name="label" translatable="yes">Adres serwera:</property>
              </object>
              <packing>
                <property name="left_attach">0</property>
                <property name="top_attach">0</property>
                <property name="width">1</property>
                <property name="height">1</property>
              </packing>
            </child>
            <child>
              <object class="GtkEntry" id="entry0">
                <property name="width_request">250</property>
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <property name="halign">end</property>
                <property name="valign">center</property>
                <property name="margin_top">8</property>
                <property name="margin_bottom">8</property>
                <property name="invisible_char">•</property>
                <property name="invisible_char_set">True</property>
              </object>
              <packing>
                <property name="left_attach">1</property>
                <property name="top_attach">0</property>
                <property name="width">1</property>
                <property name="height">1</property>
              </packing>
            </child>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">True</property>
            <property name="position">0</property>
          </packing>
        </child>
        <child>
          <object class="GtkGrid" id="grid3">
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <child>
              <object class="GtkLabel" id="label2">
                <property name="width_request">200</property>
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="xpad">25</property>
                <property name="label" translatable="yes">Nazwa  użytkownika:</property>
              </object>
              <packing>
                <property name="left_attach">0</property>
                <property name="top_attach">0</property>
                <property name="width">1</property>
                <property name="height">1</property>
              </packing>
            </child>
            <child>
              <object class="GtkEntry" id="entry1">
                <property name="width_request">100</property>
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <property name="halign">end</property>
                <property name="valign">center</property>
                <property name="margin_top">8</property>
                <property name="margin_bottom">8</property>
                <property name="invisible_char">•</property>
              </object>
              <packing>
                <property name="left_attach">1</property>
                <property name="top_attach">0</property>
                <property name="width">1</property>
                <property name="height">1</property>
              </packing>
            </child>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">True</property>
            <property name="position">1</property>
          </packing>
        </child>
        <child>
          <object class="GtkGrid" id="grid4">
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <child>
              <object class="GtkLabel" id="label3">
                <property name="width_request">200</property>
                <property name="visible">True</property>
                <property name="can_focus">False</property>
                <property name="halign">center</property>
                <property name="valign">center</property>
                <property name="xpad">2</property>
                <property name="label" translatable="yes">Hasło:</property>
                <property name="ellipsize">end</property>
              </object>
              <packing>
                <property name="left_attach">0</property>
                <property name="top_attach">0</property>
                <property name="width">1</property>
                <property name="height">1</property>
              </packing>
            </child>
            <child>
              <object class="GtkEntry" id="entry2">
                <property name="visible">True</property>
                <property name="can_focus">True</property>
                <property name="halign">center</property>
                <property name="valign">center</property>
                <property name="margin_top">8</property>
                <property name="margin_bottom">8</property>
                <property name="invisible_char">•</property>
                <property name="invisible_char_set">True</property>
              </object>
              <packing>
                <property name="left_attach">1</property>
                <property name="top_attach">0</property>
                <property name="width">1</property>
                <property name="height">1</property>
              </packing>
            </child>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">True</property>
            <property name="position">2</property>
          </packing>
        </child>
        <child>
          <object class="GtkButton" id="button">
            <property name="label" translatable="yes">Połącz z chmurą!</property>
            <property name="use_action_appearance">False</property>
            <property name="width_request">250</property>
            <property name="visible">True</property>
            <property name="can_focus">True</property>
            <property name="receives_default">True</property>
            <property name="halign">center</property>
            <property name="valign">center</property>
            <property name="margin_left">40</property>
            <property name="margin_right">37</property>
            <property name="margin_top">10</property>
            <property name="margin_bottom">10</property>
            <property name="use_action_appearance">False</property>
            <property name="xalign">0.47999998927116394</property>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">True</property>
            <property name="position">3</property>
          </packing>
        </child>
        <child>
          <object class="GtkLabel" id="label">
            <property name="visible">True</property>
            <property name="can_focus">False</property>
            <property name="halign">center</property>
            <property name="margin_left">20</property>
            <property name="margin_right">20</property>
            <property name="margin_top">20</property>
            <property name="margin_bottom">20</property>
            <property name="xalign">0</property>
            <property name="label" translatable="yes">Owncloud niezamontowany</property>
            <property name="justify">center</property>
            <property name="width_chars">1</property>
          </object>
          <packing>
            <property name="expand">False</property>
            <property name="fill">True</property>
            <property name="position">4</property>
          </packing>
        </child>
      </object>
    </child>
  </object>
</interface>
	""";


}
