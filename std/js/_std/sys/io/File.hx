/*
 * Copyright (C)2005-2012 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
package sys.io;

/**
	API for reading and writing to files.

	See `sys.FileSystem` for the complementary file system API.
**/
@:coreApi
class File {

	private static var fs : {};
	private static var path : {};

	public static function getContent( path : String ) : String {
		return untyped fs.readFileSync(path);
	}

	public static function saveContent( path : String, content : String ) : Void {
		untyped fs.writeFileSync(path, content);
	}

	public static function getBytes( path : String ) : haxe.io.Bytes {
		var o = untyped fs.openSync(path, "r");
		var s = untyped fs.fstatSync(o);
		var len = s.size, pos = 0;
		var bytes = haxe.io.Bytes.alloc(s.size);
		while( len > 0 ) {
			var r = untyped fs.readSync(o, bytes.getData(), pos, len, null);
			pos += r;
			len -= r;
		}
		untyped fs.closeSync(o);
		return bytes;
	}

	public static function saveBytes( path : String, bytes : haxe.io.Bytes ) : Void {
		var f = write(path);
		f.write(bytes);
		f.close();
	}

	public static function read( path : String, binary : Bool = true ) : FileInput {
		return untyped new FileInput(path, 'r', binary);
	}

	public static function write( path : String, binary : Bool = true ) : FileOutput {
		return untyped new FileOutput(path, 'w', binary);
	}

	public static function append( path : String, binary : Bool = true ) : FileOutput {
		return untyped new FileOutput(path, 'a', binary);
	}

	public static function copy( srcPath : String, dstPath : String ) : Void {
		untyped fs.createReadStream(srcPath).pipe(untyped fs.createWriteStream(dstPath));

	}

	public static function __init__( ) : Void {
		fs = untyped __js__("require('fs')");
		path = untyped __js__("require('path')");
	}

}
