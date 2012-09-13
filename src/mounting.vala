

class Mounting {

	private string dirPath;
	
	public Mounting(){
		dirPath = Environment.get_home_dir() + "/owncloud";   
	}

    public bool mountDevice(){
		var command = "mount " + dirPath;
		return Process.spawn_command_line_sync(command);
	}

	public bool unmountDevice(){
		var command = "umount " + dirPath;
		return Process.spawn_command_line_sync(command);
	}

	public bool isMounted(){
		var lines = getMountsFilesContent().split("\n");
		for(int i = 0; i < lines.length; i++){
			var line = lines[i];
			if(Regex.match_simple(dirPath, line)) return true;
		}

		return false;
	}

	public string getMountsFilesContent(){
        var mounts = File.new_for_path("/proc/mounts");
        var fstream = mounts.read();
        var dstream = new DataInputStream(fstream);
        var lines = dstream.read_until("",null);
        return lines;
    }

	
}
