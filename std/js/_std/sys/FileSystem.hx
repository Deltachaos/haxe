package sys;

#if !macro
/**
	This class allows you to get informations about the files and directories.
**/
@:coreApi
class FileSystem {

	private static var fs : {};
	private static var path : {};

	public static function exists( path : String ) : Bool {
		return untyped fs.existsSync(path);
	}

	public static function rename( path : String, newPath : String ) : Void {
		untyped fs.renameSync(path, newPath);
	}

	public static function stat( path : String ) : FileStat {
		var nstat : {} = untyped fs.statSync(path);
		return untyped {
		gid: nstat.gid,
		uid: nstat.uid,
		atime: Date.fromTime(nstat.atime.getTime()),
		mtime: Date.fromTime(nstat.mtime.getTime()),
		ctime: Date.fromTime(nstat.ctime.getTime()),
		size: nstat.size,
		dev: nstat.dev,
		ino: nstat.ino,
		nlink: nstat.nlink,
		rdev: nstat.rdev,
		mode: nstat.mode
		};
	}

	public static function fullPath( relPath : String ) : String {
		return untyped path.resolve(null, relPath);
	}

	public static function isDirectory( path : String ) : Bool {
#if debug
		if (!exists(path)) {
			throw "Path doesn't exist: " +path;
		}
		#end
		if ( untyped fs.statSync(path).isSymbolicLink() ) {
			return false;
		} else {
			return untyped fs.statSync(path).isDirectory();
		}
	}

	public static function createDirectory( path : String ) : Void {
		untyped fs.mkdirSync(path);
	}

	public static function deleteFile( path : String ) : Void {
		untyped fs.unlinkSync(path);
	}

	public static function deleteDirectory( path : String ) : Void {
		untyped fs.rmdirSync(path);
	}

	inline public static function readDirectory( path : String ) : Array<String> {
		return untyped fs.readdirSync(path);
	}

	public static function __init__( ) : Void {
		fs = untyped __js__("require('fs')");
		path = untyped __js__("require('path')");
	}

}

#else
class FileSystem
{}
#end
