package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import lime.math.Vector2;
import flixel.tweens.FlxEase;

class BoatData {
	public var x:Int = 0;
	public var y:Int = 0;
	public var angle:Float = 0;
	
	public var start_x:Int = 0;
	public var target_x:Int = 0;
	public var start_y:Int = 0;
	public var target_y:Int = 0;
	public var start_angle:Float = 0;
	public var target_angle:Float = 0;
	public var start_time:Int = 0;
	public var target_time:Int = 0;
	
	public var easing:EaseFunction;
    
    public var front:Boat;
    public var rear:Boat;
    
    public function new() {
        
    }
	
	public function make_current_the_start() {
		start_x = x;
		start_y = y;
		start_angle = angle;
	}
	
	public function set_start_value(_x:Int, _y:Int, _angle:Float, _time:Int) {
		start_x = _x;
		start_y = _y;
		angle = _angle;
		start_time = _time;
	}
	
	public function set_target_value(_x:Int, _y:Int, _angle:Float, _time:Int) {
		target_x = _x;
		target_y = _y;
		target_angle = _angle;
		target_time = _time;
	}
	
	
	public function set_time(time:Int) {
        var numerator:Float = time - start_time;
        var denominator:Float = target_time - start_time;
        var fraction:Float = 1;
        if (target_time != start_time) {
            fraction = numerator / denominator;
        }
        
        fraction = Math.max(0, Math.min(fraction,1));
        
        if (easing != null) {
            fraction = easing(fraction);
        }
        
		x = Std.int(start_x + (target_x - start_x) * fraction);
		y = Std.int(start_y + (target_y - start_y) * fraction);
		angle = start_angle + (target_angle - start_angle) * fraction;
	}
}