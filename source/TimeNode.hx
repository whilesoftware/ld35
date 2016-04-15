package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */

 
class TimeNode {
	
	
	
	public var time:Int;
	public var value:Dynamic;
	public var easing:EaseFunction;

	public function new(_time:Int, _value:Dynamic, _easing:EaseFunction) {
		time = _time;
		value = _value;
		easing = _easing;
	}

	public function interpolate(sample_time:Float, _node:TimeNode, _type:TimeNodeType):Dynamic {
		var numerator:Float;
		var denominator:Float;
		var fraction:Float;
		var left_position:Bool = (time <= _node.time);

		if (left_position) {
			// us to them
			numerator = sample_time - time;
			denominator = _node.time - time;
			fraction = numerator / denominator;

			if (_node.easing != null) {
				fraction = _node.easing(fraction);
			}
		}else{
			// them to us
			numerator = sample_time - _node.time;
			denominator = time - _node.time;
			fraction = numerator / denominator;

			if (easing != null) {
				fraction = easing(fraction);
			}
		}

		switch(_type) {
			case TimeNodeType.int:
				if (left_position) {
					return value + Std.int(fraction * (_node.value - value));
				}else{
					return _node.value + Std.int(fraction * (value - _node.value));
				}
			case TimeNodeType.float:
				if (left_position) {
					// us to them
					return value + fraction * (_node.value - value);
				}else{
					// them to us
					return _node.value + fraction * (value - _node.value);
				}
			case TimeNodeType.color:
				if (left_position) {
					return FlxColor.interpolate(value, _node.value, fraction);
				}else{
					return FlxColor.interpolate(_node.value, value, fraction);
				}
		}
	}
}
