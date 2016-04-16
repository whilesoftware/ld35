package;

import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxSave;



class Reg
{
	
	public static var boat1:BoatData = new BoatData();
	public static var boat2:BoatData = new BoatData();
	
	public static var frame_number:Int = 0;
	public static var frame_delta:Float = 1 / 30;
	
	public static var gamestate:GameState;
	
	public static function update(elapsed:Float) {
		frame_number++;
	}
	
	public static function timenow():Float {
		return frame_number * frame_delta;
	}
}
