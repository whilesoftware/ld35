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
	
	var clouds:FlxGroup;
	var water:FlxGroup;
	var boats:FlxGroup;
	var characters:FlxGroup;
	var arrows:FlxGroup;
	var birds:FlxGroup;
	var fishingline:FlxGroup;
	var fish:FlxGroup;
	
	
	override public function create():Void {
		frame = -1;
		
		Reg.gamestate = this;
		
		// clouds
		clouds = new FlxGroup();
		add(clouds);
		for(n in 0...FlxG.random.int(3, 10)) {
			var cloud:Cloud = new Cloud();
			clouds.add(cloud);
		}
		
		// water
		water = new FlxGroup();
		add(water);
		for(n in 0...FlxG.random.int(15, 20)) {
			var cwater:Water = new Water();
			water.add(cwater);
		}
		
		// boats
		boats = new FlxGroup();
		var boat_one = new Boat(1);
		var boat_two = new Boat(2);
		boats.add(boat_one);
		boats.add(boat_two);
		add(boats);
		
		// characters
		characters = new FlxGroup();
		add(characters);
		
		// arrows
		arrows = new FlxGroup();
		add(arrows);
		
		// birds
		birds = new FlxGroup();
		add(birds);
		
		// fishing line
		fishingline = new FlxGroup();
		add(fishingline);
		
		// fish
		fish = new FlxGroup();
		add(fish);
		
		
		
		// music
		
		// sounds
		
		state = 0;
	}
	
	override public function update(elapsed:Float):Void {
		
		FlxG.camera.bgColor = 0xff212121;
		
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

