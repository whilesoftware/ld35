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

import flixel.FlxCamera.FlxCameraFollowStyle;


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
	var oars:FlxGroup;
	var birds:FlxGroup;
	public var fishingline:FlxGroup;
	var fish:FlxGroup;
	
	public var boat1:BoatData;
	public var boat2:BoatData;
	
	public var char1:Character;
	public var char2:Character;
	
	var oar1:Oar;
	var oar2:Oar;
	
	public var player_line:FishingLine;
	
	public var camera_target:FlxSprite;
	
	
	override public function create():Void {
		
		Reg.gamestate = this;
		
		camera_target = new FlxSprite();
		camera_target.makeGraphic(1, 1, 0x0);
		add(camera_target);
		camera_target.x = FlxG.width / 2;
		camera_target.y = FlxG.height / 2;
		
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
		boat1.basex = 64;
		boat1.basey = FlxG.height - 70;
		boat1.baseangle = 0;
		boat1.set_start_value(0, 0, 0, 0);
		boat1.set_target_value(0, 0, 0, 1);
		boat1.set_time(0);
		
		boat2 = new BoatData();
		boat2.basex = FlxG.width - 128 - 64;
		boat2.basey = FlxG.height - 70;
		boat2.baseangle = 0;
		boat2.set_start_value(0, 0, 0, 0);
		boat2.set_target_value(0, 0, 0, 1);
		boat2.set_time(0);
		
		// boat rears
		boat_rears = new FlxGroup();
		var boat_one = new Boat(1, false);
		var boat_two = new Boat(2, false);
		boat_rears.add(boat_one);
		boat_rears.add(boat_two);
		boat1.rear = boat_one;
		boat2.rear = boat_two;
		add(boat_rears);
		
		// characters
		characters = new FlxGroup();
		add(characters);
		
		char1 = new Character(1);
		char2 = new Character(2);
		characters.add(char1);
		characters.add(char2);
		
		// boat fronts
		boat_fronts = new FlxGroup();
		boat_one = new Boat(1, true);
		boat_two = new Boat(2, true);
		boat_fronts.add(boat_one);
		boat_fronts.add(boat_two);
		boat1.front = boat_one;
		boat2.front = boat_two;
		add(boat_fronts);
		
		//  oars
		oars = new FlxGroup();
		add(oars);
		
		oar1 = new Oar(1);
		oar2 = new Oar(2);
		oar1.stop_rowing();
		oar2.stop_rowing();
		oars.add(oar1);
		oars.add(oar2);
		
		// arrows
		arrows = new FlxGroup();
		add(arrows);
		
		// birds
		birds = new FlxGroup();
		add(birds);
		
		// fishing line
		fishingline = new FlxGroup();
		add(fishingline);
		
		player_line = new FishingLine();
		player_line.init();
		
		// fish
		fish = new FlxGroup();
		add(fish);
		
		
		
		// music
		
		// sounds
		
		FlxG.camera.follow(camera_target, FlxCameraFollowStyle.LOCKON, 0.5);
		FlxG.camera.setScrollBoundsRect(0,0, FlxG.width, FlxG.height * 2);
		
		state = 0;
	}
	
	override public function update(elapsed:Float):Void {
		
		
		
		FlxG.camera.bgColor = 0xff212121;
		
		
		Reg.update(elapsed);
		player_line.update();
		
		switch(state) {
			case 0:
				// we're waiting for the game to start
				
				if (FlxG.keys.anyJustPressed(["SPACE"])) {
					oar1.start_rowing();
					char1.start_rowing();
				}
				
				if (FlxG.keys.anyJustReleased(["SPACE"])) {
					oar1.stop_rowing();
					char1.stop_rowing();
				}
				
				if (FlxG.keys.anyJustPressed(["C"])) {
					if (char1.is_fishing) {
						char1.start_cranking();
					}else{
						char1.start_casting();
					}
				}
				
				if (FlxG.keys.anyJustPressed(["1"])) {
					camera_target.y = FlxG.height * 0.5;
				}
				if (FlxG.keys.anyJustPressed(["Q"])) {
					camera_target.y = FlxG.height * 0.55;
				}
				if (FlxG.keys.anyJustPressed(["W"])) {
					camera_target.y = FlxG.height * 1.15;
				}
				if (FlxG.keys.anyJustPressed(["E"])) {
					camera_target.y = FlxG.height * 1.2;
				}
				if (FlxG.keys.anyJustPressed(["R"])) {
					camera_target.y = FlxG.height * 1.3;
				}
				

			case 1:
				// the game is running
				
			case 2:
				// the game just ended
		}
		
		// update the boat animation target?
		if (boat1.target_time <= Reg.frame_number) {
			trace("setting new boat1 target");
			boat1.make_current_the_start();
			// pick a new target
			boat1.set_target_value(
				FlxG.random.int(-12,12), 
				FlxG.random.int(-4,5), 
				FlxG.random.float(-4,4),
				Reg.frame_number + FlxG.random.int(90,240));
		}
		
		if (boat2.target_time <= Reg.frame_number) {
			boat2.make_current_the_start();
			// pick a new target
			boat2.set_target_value(
				FlxG.random.int(-12,12), 
				FlxG.random.int(-4,5), 
				FlxG.random.float(-4,4),
				Reg.frame_number + FlxG.random.int(90,240));
		}
		
		
		boat1.set_time(Reg.frame_number);
		boat2.set_time(Reg.frame_number);
		
		
		boat1.front.set(boat1);
		boat1.rear.set(boat1);
		oar1.set(boat1);
		char1.set(boat1);
		
		boat2.front.set(boat2);
		boat2.rear.set(boat2);
		oar2.set(boat2);
		char2.set(boat2);
		
		
		
		super.update(elapsed);
		

	}
}

