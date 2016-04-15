package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxVector;

/**
 * ...
 * @author while(software)
 */

enum Simstate {
	grounded;
	jumping;
	airborn; 
	prejump;
	dead;
}

class Dude extends FlxGroup {
	
	var point_vector:FlxVector;
	
	var cstate:Simstate = Simstate.airborn;
	var cstate_start_time:Float;
	var pstate:Simstate = Simstate.airborn;
	var pstate_start_time:Float;
	
	var grounded_accel:Float = 1800;
	var grounded_decel:Float = 3000;
	var air_accel:Float = 600;
	var air_decel:Float = 300;
	var terminal_velocity:Float = 300;
	var prejump_length:Float = 1.1 / 60;
	var velocity:Vector2 = new Vector2(0,0);
	var previous_velocity:Vector2 = new Vector2(0,0);
	//var accel:Vector2 = new Vector2(0,0);
	var gravity:Vector2 = new Vector2(0, 5000);
	
	var jump_linear_rate:Float = -400;
	var max_initial_jump_time:Float = 0.2;
	
	var external_motion:Vector2 = new Vector2(0, 0);
	var requested_change_in_position:Vector2 = new Vector2(0, 0);
	var user_requested_x_velocity:Float = 0;
	
	var time_now:Float = 0;
	var time_previous_frame:Float = -1;
	var time_delta:Float = 1;
	
	var use_prejump:Bool = true;
	
	var tvec2:Vector2 = new Vector2(0, 0);
	
	function is_grounded():Bool {
		return cstate == Simstate.grounded;
	}
	function is_jumping():Bool {
		return cstate == Simstate.jumping;
	}
	function is_airborn():Bool {
		return cstate == Simstate.airborn;
	}
	function is_prejumping():Bool {
		return cstate == Simstate.prejump;
	}
	
	function was_grounded():Bool {
		return pstate == Simstate.grounded;
	}
	function was_jumping():Bool {
		return pstate == Simstate.jumping;
	}
	function was_airborn():Bool {
		return pstate == Simstate.airborn;
	}
	function was_prejumping():Bool {
		return pstate == Simstate.prejump;
	}
	
	function SetSimulationState(newstate:Simstate, start_time:Float) {
		//trace("***** New simstate: " + newstate);
		cstate = newstate;
		cstate_start_time = start_time;
	}
	
	function add_motion(motion_to_add:Vector2, reason:String = "") {
		external_motion.x += motion_to_add.x;
		external_motion.y += motion_to_add.y;
		
		//trace("adding motion: " + motion_to_add.x + "," + motion_to_add.y + " - " + reason);
	}
	
	function add_x_motion(motion_to_add:Float, reason:String = "") {
		tvec2.setTo(motion_to_add, 0);
		add_motion(tvec2, reason);
	}
	function add_y_motion(motion_to_add:Float, reason:String = "") {
		tvec2.setTo(0, motion_to_add);
		add_motion(tvec2, reason);
	}
	
	
	public var height:Int = 32;
	public var width:Int = 32;
	
	public var x:Float = 0;
	public var y:Float = 0;
	
	var previous_x:Float = 0;
	var previous_y:Float = 0;
	
	
	
	var body:FlxSprite = new FlxSprite();
	var legs:FlxSprite = new FlxSprite();
	var gun:FlxSprite = new FlxSprite();
	
	var horizontal_input:Float = 0;
	var jump_input:Bool = false;
	var mouse_position:FlxPoint;
	var fire_input:Bool = false;

	public function new() 
	{
		super();
		
		point_vector = new FlxVector();
		
		body.loadGraphic("assets/images/dude-again.png", true, width, height);
		body.animation.add("cycle", [1, 2, 3, 4, 5], 10, true);
		add(body);
		body.animation.play("cycle");
		
		legs.loadGraphic("assets/images/dude-again.png", true, width, height);
		legs.animation.add("still", [6], 10, false);
		legs.animation.add("jumping", [7], 10, false);
		legs.animation.add("running", [8, 9, 10, 11], 20, true);
		legs.animation.add("falling", [12], 20, false);
		add(legs);
		
		// 12,12 is at 16,23
		gun.loadGraphic("assets/images/gun.png", false, 24, 24);
		Reg.gamestate.gun_group.add(gun);
	}
	

	
	public function reset() {
		x = FlxG.width / 2 - width / 2;
		y = FlxG.height - height - 19;
		
		
		
		// we start with no assumptions. 
		// let the simulation determine that we're grounded
		SetSimulationState(Simstate.airborn, 0);
		
		set_position();
	}
	
	function gather_input() {
		horizontal_input = 0;
		
		// get input
		if (FlxG.keys.anyPressed(["A", "LEFT"])) {
			horizontal_input = -1;
		}else if (FlxG.keys.anyPressed(["D", "RIGHT"])) {
			horizontal_input = 1;
		}
		
		jump_input = FlxG.keys.anyPressed(["SPACE"]);
		
		
		fire_input = FlxG.mouse.pressed;
		
		
		mouse_position = FlxG.mouse.getWorldPosition();

	}
	
	function process_input() {
		if (use_prejump) {
			if (is_grounded()) {
				if (jump_input) {
					SetSimulationState(Simstate.prejump, time_now);
				}
			}
			
			if (is_prejumping()) {
				if (time_now - cstate_start_time >= prejump_length) {
					SetSimulationState(Simstate.jumping, cstate_start_time + prejump_length);
				}
			}
		}else {
			if (is_grounded()) {
				if (jump_input) {
					SetSimulationState(Simstate.jumping, time_now - time_delta);
				}
			}
		}
		
		if (is_jumping()) {
			var jumping_motion:Float = 0;
			var fraction_of_time_spent_jumping:Float = 0;
			// has the max_jump_time expired?
			if (time_now - cstate_start_time > max_initial_jump_time) {
				// retroactively switch to the airborn state, 
				// accounting for the fraction of the last frame that was truly spent 'jumping'
				// and the fraction that was spent 'airborn'
				fraction_of_time_spent_jumping = cstate_start_time + max_initial_jump_time - time_previous_frame;
				SetSimulationState(Simstate.airborn, cstate_start_time + max_initial_jump_time);
				
				jumping_motion = jump_linear_rate * fraction_of_time_spent_jumping + 0.5 * gravity.y * Math.pow(fraction_of_time_spent_jumping, 2);
				add_y_motion(jumping_motion, "partial frame jump motion");
			}else {
				// has the user stopped holding jump?
				if (! jump_input) {
					// immediately switch to airborn
					SetSimulationState(Simstate.airborn, time_now);
					
					// create an external force representing the 'jumping' movement that should be applied
					jumping_motion = jump_linear_rate * time_delta + 0.5 * gravity.y * Math.pow(time_delta, 2);
					add_y_motion(jumping_motion, "jump motion (switching to airborn)");
				}
			}
		}
		
		user_requested_x_velocity = horizontal_input * terminal_velocity;
	}
	
	function apply_forces() {
		var previous_x_velocity:Float = velocity.x;
		var new_x_velocity:Float = 0;
		var multiplier:Float = 0;
		var xf:Float = 0;
		
		//trace("target velocity: " + user_requested_x_velocity);
		
		if (user_requested_x_velocity < previous_x_velocity) {
			multiplier = -1;
		}else if (user_requested_x_velocity > previous_x_velocity) {
			multiplier = 1;
		}
		
		// we're currently moving at N m/s, but we want to move at M m/s
		if (Math.abs(user_requested_x_velocity) < Math.abs(previous_x_velocity)) {
			// decelerate towards the target
			if (is_grounded() || is_prejumping() ) {
				xf = grounded_decel;
			}else {
				xf = air_decel;
			}
		}else {
			// accelerate towards the target
			if (is_grounded() || is_prejumping() ) {
				xf = grounded_accel;
			}else {
				xf = air_accel;
			}
		}
		
		if ((user_requested_x_velocity > 0 && previous_x_velocity < 0) ||
		    (user_requested_x_velocity < 0 && previous_x_velocity > 0)) {
			// we're going from one direction to another.
			// use the fastest method available (accel vs. decel)
			if (is_grounded() || is_prejumping()) {
				xf = Math.max(grounded_accel, grounded_decel);
			}else {
				xf = Math.max(air_accel, air_decel);
			}
		}
		
		new_x_velocity = velocity.x + multiplier * xf * time_delta;
		
		// copnstrain the values to +/- terminal velocity
		new_x_velocity = Math.min(terminal_velocity, Math.max( -terminal_velocity, new_x_velocity));
		
		if (user_requested_x_velocity < previous_x_velocity) {
			new_x_velocity = Math.max(user_requested_x_velocity, new_x_velocity);
		}else {
			new_x_velocity = Math.min(user_requested_x_velocity, new_x_velocity);
		}
		
		add_x_motion(new_x_velocity * time_delta, "user's x input");
		
		if (is_airborn()) {
			var airborn_time_to_apply = Math.min(time_now - cstate_start_time, time_delta);
			add_y_motion(velocity.y * airborn_time_to_apply, "airborn motion");
		}
		
		// add gravity
		add_motion(new Vector2(0.5 * gravity.x * Math.pow(time_delta, 2), 0.5 * gravity.y * Math.pow(time_delta, 2)), "gravity");
		
		// add motion from jumping
		if (is_jumping()) {
			var jumping_dt:Float = Math.min(time_now - cstate_start_time, time_delta);
			
			add_y_motion(jump_linear_rate * jumping_dt, "actively jumping");
			
			// the 'undo gravity' part (what lets our linear jumping rates actually work
			add_y_motion( -0.5 * gravity.y * Math.pow(time_delta, 2), "undo gravity");
		}
		
		
		//x += Std.int(3 * horizontal_input);
	}
	
	function resolve_collisions_and_update_simstate() {
		var new_y:Float = y + external_motion.y;
		var new_x:Float = x + external_motion.x;
		
		var ground_position:Float = FlxG.height - 19 - height;
		
		if (new_y >= ground_position) {
			new_y = ground_position;
			// we're on the ground
			if (! is_grounded() && ! is_prejumping()) {
				SetSimulationState(Simstate.grounded, time_now);
			}
		}
		
		// stay within the screen bounds
		if (new_x < 0) {
			new_x = 0;
		}
		if (new_x > FlxG.width - width) {
			new_x = FlxG.width - width;
		}
		
		x = new_x;
		y = new_y;
		
		velocity.x = (x - previous_x) / time_delta;
		velocity.y = (y - previous_y) / time_delta;
	}
	
	function animate() {
		point_right(mouse_position.x >= x + 16);
		
		switch(cstate) {
			case Simstate.grounded:
				// we're either running or standing still
				if (Math.abs(velocity.x) > 0 ) {
					if (body.animation.name != "running") {
						legs.animation.play("running");
					}
					
				}else {
					legs.animation.play("still");
				}
				
			case Simstate.airborn:
				if (velocity.y < 0) {
					legs.animation.play("jumping");
				}else {
					legs.animation.play("falling");
				}
			case Simstate.jumping:
				legs.animation.play("jumping");
			default:
		}
		
		set_position();
	}
	
	function point_right(_bool:Bool) {
		body.flipX = ! _bool;
		legs.flipX = ! _bool;
		gun.flipX = ! _bool;
	}
	
	function set_position() {
		var _x:Int = Std.int(x);
		var _y:Int = Std.int(y);
		
		legs.setPosition(_x, _y);
		
		if (is_prejumping()) {
			_y += 2;
		}
		if (is_jumping()) {
			_y -= 2;
		}
		if (is_grounded() && (time_now-cstate_start_time < 0.1)) {
			_y += 2;
		}
		
		body.setPosition(_x, _y);
		
		gun.setPosition(_x + 4, _y + 9);
		
		// point the gun at the mouse's location
		if (mouse_position != null) {
			point_vector.x = (mouse_position.x + 0) - (x + 16);
			point_vector.y = (mouse_position.y + 0) - (y + 23);
			gun.angle = point_vector.degrees;
			if (mouse_position.x < x + 16) {
				gun.angle += 180;
			}
		}
	}
	
	public override function update(elapsed:Float) {
		super.update(elapsed);
		
		//trace("----------- frame: " + Reg.frame_number);
		//trace("dude is at: " + x + "," + y);
		//trace("dude has velocity: " + velocity.x + "," + velocity.y);
		
		previous_x = x;
		previous_y = y;
		
		/*
		time_previous_frame = time_now;
		time_now = Reg.timenow();
		time_delta = time_now - time_previous_frame;
		*/
		time_now = Reg.timenow();
		time_delta = Reg.frame_delta;
		time_previous_frame = time_now - time_delta;
		
		external_motion.setTo(0, 0);
		requested_change_in_position.setTo(0, 0);
		
		pstate = cstate;
		pstate_start_time = cstate_start_time;
		
		// check for input
		gather_input();
		
		// update state
		process_input();
		
		// apply forces
		apply_forces();
		
		// resolve collisions
		resolve_collisions_and_update_simstate();
		
		animate();

		// should we spray a water particle?
		if (fire_input) {
			Reg.gamestate.watersound.volume = 0.5;
			
			// create a new water particle
			var new_water:WaterParticle = new WaterParticle();
			Reg.gamestate.waters.add(new_water);
			
			point_vector.normalize();
			
			var startx:Float = x + 15 + point_vector.x * 12;
			var starty:Float = y + 22 + point_vector.y * 12;
			
			// set it in motion
			new_water.gobabygo(startx, starty, point_vector.x, point_vector.y);
		}else {
			Reg.gamestate.watersound.volume = 0;
		}
	}
}
