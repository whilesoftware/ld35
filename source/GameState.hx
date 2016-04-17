package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.input.keyboard.FlxKey;

import flixel.FlxCamera.FlxCameraFollowStyle;

import nape.geom.Vec2;


/**
 * ...
 * @author while(software)
 */
class GameState extends FlxState {
	
	public var state:Int = -1;
	
	var is_reversed:Bool = true;
	
	var clouds:FlxGroup;
	var water:FlxGroup;
	var boat_fronts:FlxGroup;
	var boat_rears:FlxGroup;
	var characters:FlxGroup;
	var arrows:FlxGroup;
	var oars:FlxGroup;
	var birds:FlxGroup;
	public var fishingline:FlxGroup;
	var fish:FlxTypedGroup<Fish>;
	
	public var boat1:BoatData;
	var _boat1_front:Boat;
	var _boat1_back:Boat;
	
	public var char1:Character;
	
	var oar1:Oar;
	
	public var player_line:FishingLine;
	
	public var camera_target:FlxSprite;
	
	var title:FlxSprite;
	
	public var bgcolor_timeline:Timeline;
	
	var waterbg:FlxSprite;
	
	override public function create():Void {
		
		Reg.gamestate = this;
		
		bgcolor_timeline = new Timeline();
		bgcolor_timeline.type = TimeNodeType.color;
		
		//bgcolor_timeline.nodes.push(new TimeNode(0, ))w
		
		camera_target = new FlxSprite();
		camera_target.makeGraphic(1, 1, 0x0);
		add(camera_target);
		camera_target.x = FlxG.width / 2;
		camera_target.y = FlxG.height / 2;
		
		// waterbg
		waterbg = new FlxSprite();
		waterbg.loadGraphic("assets/images/waterbg.png", false, 640, 640);
		waterbg.x = 0;
		waterbg.y = FlxG.height - 80;
		add(waterbg);
		
		
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
		boat1.basex = FlxG.width - 128 - 64;
		boat1.basey = FlxG.height - 70;
		boat1.baseangle = 0;
		boat1.set_start_value(0, 0, 0, 0);
		boat1.set_target_value(0, 0, 0, 1);
		boat1.set_time(0);
		
		// boat rears
		boat_rears = new FlxGroup();
		var boat_one = new Boat(false);
		_boat1_back = boat_one;
		boat_rears.add(boat_one);
		boat1.rear = boat_one;
		add(boat_rears);
		
		// characters
		characters = new FlxGroup();
		add(characters);
		
		char1 = new Character(1);
		characters.add(char1);
		
		
		// boat fronts
		boat_fronts = new FlxGroup();
		boat_one = new Boat(true);
		_boat1_front = boat_one;
		boat_fronts.add(boat_one);
		boat1.front = boat_one;
		add(boat_fronts);
		
		//  oars
		oars = new FlxGroup();
		add(oars);
		
		oar1 = new Oar();
		oar1.stop_rowing();
		oars.add(oar1);
		
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
		fish = new FlxTypedGroup<Fish>();
		add(fish);
		
		// start with 3 fish
		for(n in 0...3) {
			var _fish:Fish = new Fish();
			fish.add(_fish);
		}
		
		title = new FlxSprite();
		title.loadGraphic("assets/images/title.png", true, 256, 64);
		title.animation.add("title", [0, 1, 2, 3, 4], 4, true);
		
		title.x = FlxG.width - 256 - 64;
		title.y = 64;
		title.alpha = 0;
		title.animation.play("title");
		add(title);
		
		
		// music
		
		// sounds
		
		FlxG.camera.follow(camera_target, FlxCameraFollowStyle.LOCKON, 0.005);
		FlxG.camera.setScrollBoundsRect(0,0, FlxG.width, FlxG.height * 2);
		
	}
	
	function set_reversed(value:Bool) {
		is_reversed = value;
		char1.set_reversed(value);
		oar1.set_reversed(value);
		_boat1_front.set_reversed(value);
		_boat1_back.set_reversed(value);
	}
	
	private function hook_a_fish(_fish:FlxObject, _hook:FlxObject):Void {
		
		trace("hit a fish");
		
		// don't hook unless we're near the center of the fish
		if (Math.abs(_fish.x - _hook.x) > 20) {
			return;
		}
		
		var the_fish:Fish = cast(_fish,Fish);
		
		the_fish.hook_fish();
	}
	
	public function watch_fish_get_hooked() {
		FlxG.camera.follow(camera_target, FlxCameraFollowStyle.LOCKON, 0.05);
		camera_target.y = FlxG.height / 2;
		
		new FlxTimer().start(3).onComplete = function(t:FlxTimer):Void {
			FlxG.camera.follow(camera_target, FlxCameraFollowStyle.LOCKON, 0.005);
			camera_target.y = FlxG.height * 1.15;
		}
		
	}
	
	override public function update(elapsed:Float):Void {
		
		
		
		FlxG.camera.bgColor = 0xff212121;
		//FlxG.camera.bgColor = 0xff98d9f7;
		
		
		Reg.update(elapsed);
		player_line.update();
		
		switch(state) {
			case -1:
				// kick things off
				FlxTween.tween(title, { alpha: 1 }, 1);
				
				
				set_reversed(true);
				
				char1.start_rowing();
				oar1.start_rowing();
				
				if (boat1.target_time <= Reg.frame_number) {
					trace("setting initial boat1 target");
					boat1.make_current_the_start();
					// pick a new target
					boat1.set_target_value( 
						-350,  
						FlxG.random.int(-4,5), 
						1,
						Reg.frame_number + 800);
				}
				
				state = 0;
				
			case 0:
				// we're waiting for the game to start
				if (FlxG.keys.pressed.SPACE) {
					state = 1;
					
					// play start sound
					
					// switch to fishing mode
					char1.stop_rowing();
					oar1.stop_rowing();
					
					// hurry up and move the boat into position
					trace("setting new boat1 target");
					boat1.make_current_the_start();
					// pick a new target
					boat1.set_target_value(
						-350 + FlxG.random.int(-18,18), 
						FlxG.random.int(-7,8), 
						FlxG.random.float(-6,6),
						Reg.frame_number + FlxG.random.int(90,180));
					
					// set new camera target
					camera_target.y = FlxG.height * 1.15;
				}
				
				// update the boat animation target?
				if (boat1.target_time <= Reg.frame_number) {
					trace("setting new boat1 target");
					boat1.make_current_the_start();
					// pick a new target
					boat1.set_target_value(
						-350 + FlxG.random.int(-18,18), 
						FlxG.random.int(-7,8), 
						FlxG.random.float(-6,6),
						Reg.frame_number + FlxG.random.int(90,180));
				} 
				

			case 1:
				// the game is running
				 
				// if the hook is being cranked, check for collisions
				if (player_line.is_cranking) {
					// walk the list of fish
					var hookx:Float = player_line.hook.body.position.x;
					var hooky:Float = player_line.hook.body.position.y;
					
					for (_fish in fish.members) {
						if (_fish.state != 0) {
							continue;
						}
						
						if (hookx >= _fish.x && hookx <= _fish.x + 53) {
							if (hooky >= _fish.y + 18 && hooky <= _fish.y + 52) {
								_fish.hook_fish();
								watch_fish_get_hooked();
							}
						}
						
						/*
						if (_fish.y < player_line.hook.body.position.y + 20 && 
						    _fish.y > player_line.hook.body.position.y - 20) {
								if (_fish.x < player_line.hook.body.position.x + 20 &&
								    _fish.x > player_line.hook.body.position.x - 20) {
										trace("we hit a fish!");
										_fish.hook_fish();
									}
							}
						*/
					}
				
				}
								
								/*
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
					set_reversed(!is_reversed);
					char1.start_rowing();
					oar1.start_rowing();
				}
				*/
				
				if (FlxG.keys.anyJustPressed(["SPACE"])) {
					if (char1.is_fishing) {
						char1.start_cranking();
					}else{
						char1.start_casting();
					}
				}
				
				if (FlxG.keys.pressed.RIGHT) {
					char1.move_hook(new Vec2(5,0));
				}
				if (FlxG.keys.pressed.LEFT) {
					char1.move_hook(new Vec2(-5,0));
				}
				if (FlxG.keys.pressed.UP) {
					char1.move_hook(new Vec2(0,-3));
				}
				if (FlxG.keys.pressed.DOWN) {
					char1.move_hook(new Vec2(0,3));
				}
				
				// update the boat animation target?
				if (boat1.target_time <= Reg.frame_number) {
					trace("setting new boat1 target");
					boat1.make_current_the_start();
					// pick a new target
					boat1.set_target_value(
						-350 + FlxG.random.int(-18,18), 
						FlxG.random.int(-7,8), 
						FlxG.random.float(-6,6),
						Reg.frame_number + FlxG.random.int(90,180));
				}
				
			case 2:
				// the game just ended
		}
		
		
		
		
		boat1.set_time(Reg.frame_number);
		
		
		boat1.front.set(boat1);
		boat1.rear.set(boat1);
		oar1.set(boat1);
		char1.set(boat1);
		
		
		super.update(elapsed);
		

	}
}

