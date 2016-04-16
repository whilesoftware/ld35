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
	var boat_fronts:FlxGroup;
	var boat_rears:FlxGroup;
	var characters:FlxGroup;
	var arrows:FlxGroup;
	var birds:FlxGroup;
	var fishingline:FlxGroup;
	var fish:FlxGroup;
	
	var boat1:BoatData;
	var boat2:BoatData;
	
	
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
		
		// boat fronts
		boat_fronts = new FlxGroup();
		var boat_one = new Boat(1, true);
		var boat_two = new Boat(2, true);
		boat_fronts.add(boat_one);
		boat_fronts.add(boat_two);
		add(boat_fronts);
		
		// characters
		characters = new FlxGroup();
		add(characters);
		
		// boat rears
		boat_rears = new FlxGroup();
		boat_one = new Boat(1, false);
		boat_two = new Boat(2, false);
		boat_rears.add(boat_one);
		boat_rears.add(boat_two);
		add(boat_rears);
		
		// boat data
		boat1 = new BoatData();
		boat1.x = 64;
		boat1.y = FlxG.height - 70;
		boat1.target_time = 0;
		
		boat2 = new BoatData();
		boat2.x = FlxG.width - 128 - 64;
		boat2.y = FlxG.height - 70;
		boat2.target_time = 0;
		
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

