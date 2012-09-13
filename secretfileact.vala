/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* owncloud_mount
 *
 * Copyright (C) Mikołaj Sochacki 2012 mikolajsochacki gmail com
 * owncloud_mount license: GPL v3
	 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class SecretFileAct : Object  {
	private string davDirPath;
	private string password;
	private string userName;
	private string serverPath;
	private string fileSecretName;

	public SecretFileAct () {
		fileSecretName = "/secrets";
		davDirPath = Environment.get_home_dir() + "/.davfs2";
		createDataStringAndPassword();
	}
	
	public void setServerPath(string path) { this.serverPath = path; }

	public string getPassword(){ return password; }

	public string getUserName(){ return userName; }

	public string getServerPath() { return serverPath; }

    public void save(string server, string user, string password) {
		var line = server + " " + user + " " + password;
		var file = File.new_for_path(davDirPath + fileSecretName);
		if (file.query_exists()) file.delete();
		var dostream = new DataOutputStream(file.create(FileCreateFlags.PRIVATE));
		dostream.put_string(line);
	}

	private string readSecretFile(){
		var file = File.new_for_path(davDirPath + fileSecretName);
		if(!file.query_exists()) { 
			var devDir = File.new_for_path(davDirPath);
			if(!devDir.query_exists()) {
				devDir.make_directory();
			}
		}
		var input_file = File.new_for_path(davDirPath + fileSecretName);
		if(!input_file.query_exists()) {
			input_file.create(FileCreateFlags.PRIVATE);
			return "";
		} 
		else {
			var fstream = input_file.read();
			var dstream = new DataInputStream(fstream);
			var content = dstream.read_until("", null);
			fstream.close();
			return content; 
		}
	}

	private void createDataStringAndPassword(){
		var fileContent = readSecretFile();
		var lines = fileContent.split("\n");
		for(int i = 0; i < lines.length; i++){
			var line = lines[i].strip();
			var data = line.split(" ");
			if(data.length > 0 && data[0].has_prefix("htt")){
					serverPath = data[0];
					if(data.length == 3) {
						password = data[2];
						userName = data[1];
					}
					return;		
			}
		}
		return;
	}

	
	

}
