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
		
		// boat data
		boat1 = new BoatData();
		boat1.set_start_value(64, FlxG.height - 70, 0, 0);
		boat1.set_target_value(64, FlxG.height - 70, 0, 1);
		
		boat2 = new BoatData();
		boat2.set_start_value(FlxG.width - 128 - 64, FlxG.height - 70, 0, 0);
		boat2.set_target_value(FlxG.width - 128 - 64, FlxG.height - 70, 0, 1);
		
		// boat fronts
		boat_fronts = new FlxGroup();
		var boat_one = new Boat(1, true);
		var boat_two = new Boat(2, true);
		boat_fronts.add(boat_one);
		boat_fronts.add(boat_two);
		boat1.front = boat_one;
		boat2.front = boat_two;
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
		boat1.rear = boat_one;
		boat2.rear = boat_two;
		add(boat_rears);
		
		
		
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
		
		Reg.update(elapsed);
		
		switch(state) {
			case 0:
				// we're waiting for the game to start

			case 1:
				// the game is running
				
			case 2:
				// the game just ended
		}
		
		boat1.set_time(Reg.frame_number);
		boat2.set_time(Reg.frame_number);
		
		boat1.front.set(boat1);
		boat1.rear.set(boat1);
		boat2.front.set(boat2);
		boat2.rear.set(boat2);
		
		
		super.update(elapsed);
		
		

	}
}

