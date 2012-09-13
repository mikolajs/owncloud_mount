/* -*- Mode: vala; tab-width: 4; intend-tabs-mode: t -*- */
/* owncloud_mount
 *
 * Copyright (C) Mikołaj Sochacki 2012 mikolajsochacki gmail com
	 * owncloud_mount is 
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
	 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class SecretFileAction  {
	private string homeDirPath;
	private string password;
	private string userName;
	private string serverPath;

	public SecretFileAction (string serverPath) {
		this.serverPath = serverPath;
		homeDirPath = Enviroinment.get_home_dir();
		createDataStringAndPassword();
	}


	private string readSecretFile(){
		var dirStr = homeDirPath + "/.davfs2";
		var fileStr = "/secrets";
		var file = File.new_for_path(dirStr + fileStr);
		if(!file.query_exists()) { 
			var devDir = File.new_for_path(dirStr);
			if(!devDir.query_exists()) {
				devDir.make_directory();
			}
		}
		var input_file = File.new_for_path(dirStr + fileStr);
		if(!input_file.query_exists()) {
			input_file.create();
			return "";
		} 
		else {
			var fstream = input_file.read();
			var dstream = new DataInputStream.c_new(fstream);
			var content = dstream.read_until("", 0);
			fstream.close();
			print(content);
			return content; 
		}
	}

	private void createDataStringAndPassword(){
		var fileContent = readSecretFile();
		var lines = fileContent.split("\n");
		for(int i = 0; i < lines.length; i++){
			var line = lines[i].strip();
			if(line.has_prefix(this.serverPath)){
				var data = line.split(" ");
				if(data.length == 3){
					password = data[2];
					userName = data[1];
					return;
				}	
			}
		}
		return;
	}

	public string getPassword(){
		return password;
	}

	public string getUserName(){
		return userName;
	}

}
