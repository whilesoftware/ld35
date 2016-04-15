package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;

/**
 * ...
 * @author while(software)
 */
class GameState extends FlxState {
	public var frame:Int;
	
	public var state:Int = -1;
	
	
	override public function create():Void {
		frame = -1;
		
		Reg.gamestate = this;
		
		state = 0;
	}
	
	override public function update(elapsed:Float):Void {
		
		FlxG.camera.bgColor = 0xff600000;
		
		switch(state) {
			case 0:
				// we're waiting for the game to start

			case 1:
				// the game is running, update the frame count
				frame++;
				
			case 2:
				// the game just ended
		}
		
		
		
		super.update(elapsed);
		
		Reg.update(elapsed);

	}
}

