package;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class MathHelper 
{
	public static function RandomRangeFloat(min:Float, max:Float) {
		return Math.random() * (max - min) + min;
	}
	
	public static function RandomRangeInt(min:Int, max:Int) {
		return Math.round(Math.random() * (max - min)) + min;
	}

	public static function CenterSprite(sprite:FlxSprite, axes:String) {
		switch(axes) {
			case "x":
				sprite.x = Std.int(FlxG.width / 2 - sprite.width / 2);
			case "y":
				sprite.y = Std.int(FlxG.height / 2 - sprite.height / 2);
			case "xy":
				sprite.x = Std.int(FlxG.width / 2 - sprite.width / 2);
				sprite.y = Std.int(FlxG.height / 2 - sprite.height / 2);
		}
	}
	
}
