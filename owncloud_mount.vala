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
	const string UI_FILE = "owncloud_mount.ui";

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
			builder.add_from_file (UI_FILE);
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
}
