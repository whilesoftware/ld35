package;

import flash.display.Graphics;
import flash.geom.Rectangle;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeSpace;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.math.FlxRandom;
import flixel.util.FlxSpriteUtil;

import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.DistanceJoint;
import nape.constraint.PivotJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;

import flixel.util.FlxTimer;


class FishingLine {
    public var joints:Array<DistanceJoint>;
    
    var fishing_pole:Body;
    
    static var MAX_LENGTH = 250;
    static var NUM_SEGMENTS = 20;
    
    var lineSprite:FlxSprite;
    public var hook:FlxNapeSprite;
    var pole:FlxNapeSprite;
    
    var destroy_timer:FlxTimer;
    
    private static var nape_started:Bool = false;
    
    public var is_active:Bool = false;
    public var is_cranking:Bool = false;
    
    var polejoint:DistanceJoint = null;
    
    var new_cast:Bool = false;
    var pre_cast:Bool = false;
    
    var cosmetic_hook:FlxSprite;
    
    public function new() {
        
    }
    
    public function init() {
        
        if (!nape_started) {
            FlxNapeSpace.init();
        
            FlxNapeSpace.space.gravity.setxy(0, 500);
            FlxNapeSpace.createWalls(-100, -100, FlxG.width + 100, FlxG.height * 3);
            //FlxNapeSpace.createWalls(0, 0, FlxG.width, FlxG.height);
            
            nape_started = true;
        }
        
        // define the object that the line will connect to (something that tracks the position of the end of the rod)
        pole = new FlxNapeSprite(Reg.gamestate.boat1.x, Reg.gamestate.boat1.y, "assets/images/empty.png");
        pole.setBodyMaterial(1, .2, .4, .5);
        set_pole_position();
        
        pole.visible = false;
        
        Reg.gamestate.fishingline.add(pole);
        
        // define the object that the line will connect to (the hook/bait)
        hook = new FlxNapeSprite(FlxG.width / 2, FlxG.height / 2, "assets/images/hook-1.png");
        
        hook.antialiasing = true;
        hook.setBodyMaterial(1, .2, .4, .5);
        
        hook.visible = false;
        
        /*
        cosmetic_hook = new FlxSprite();
        cosmetic_hook.loadGraphic("assets/images/hook.png", true, 32, 32, true);
        cosmetic_hook.animation.add("default", [0, 1, 2, 3], 3, true, false, false);
        cosmetic_hook.animation.play("default");
        cosmetic_hook.visible = false;
        */
        
        //Reg.gamestate.fishingline.add(cosmetic_hook);
        
        Reg.gamestate.fishingline.add(hook);
        
        // create a fullscreen-sized FlxSprite to which we'll render the lines
        lineSprite = new FlxSprite();
        lineSprite.makeGraphic(FlxG.width, FlxG.height, 0x0);
        Reg.gamestate.fishingline.add(lineSprite);
        lineSprite.visible = false;
        
    }
    
    public function precast() {
        pre_cast = true;
        reset_hook();
    }
    
    public function reset_hook() {
        hook.body.position.x = pole.body.position.x - 38;
        hook.body.position.y = pole.body.position.y - 34;
        hook.body.velocity.x = 0;
        hook.body.velocity.y = 0;
        hook.visible = true;
    }
    
    public function cast_new_line(xvec:Float, yvec:Float) {
        
        // cancel any pending destroy calls
        if (destroy_timer != null) {
            destroy_timer.cancel();
        }
        
        if (joints != null) {
            for (joint in joints) {
                joint.space = null;
            }
        }
        
        new_cast = true;
        pre_cast = false;
        
        // clear out any existing joint objects
        joints = new Array<DistanceJoint>();
        
        // lookup the start position
        set_pole_position();
        
        hook.body.position.x = pole.body.position.x - 38;
        hook.body.position.y = pole.body.position.y - 34;
        
        // create new segments
        var offset_hook:Vec2 = new Vec2(0,-16);
        var zero_offset:Vec2 = new Vec2(0,-1);
        var circle:Body;
        var startpos:Vec2;
        var distx:Float;
        var disty:Float;
        var distJoint:DistanceJoint;
        
        var body1:Body = pole.body;
        var anchor1:Vec2 = zero_offset;
        
        distx = hook.body.position.x - pole.body.position.x;
        disty = hook.body.position.y - pole.body.position.y;
        
        
        for (i in 1...NUM_SEGMENTS) {
            // set the start pos
            startpos = new Vec2(body1.position.x + distx / NUM_SEGMENTS, body1.position.y + disty / NUM_SEGMENTS);
            
            // create a new Body from a circle
            circle = new Body(BodyType.DYNAMIC, startpos);
            circle.shapes.add(new Circle(5));
            circle.space = FlxNapeSpace.space;
            circle.shapes.at(0).filter.collisionGroup = 2;
            circle.shapes.at(0).filter.collisionMask = ~2;
            
            // create a new distance joint
            if (i == 1) {
                distJoint = new DistanceJoint(
                    FlxNapeSpace.space.world, 
                    circle, 
                    new Vec2(pole.body.position.x, pole.body.position.y), 
                    circle.localCOM, 
                    0, 
                    0);
                    
                distJoint.frequency = 5;
                distJoint.space = FlxNapeSpace.space;
                
                polejoint = distJoint;
            }else{
                distJoint = new DistanceJoint(body1, circle, anchor1.add(body1.localCOM), circle.localCOM, 0, MAX_LENGTH / NUM_SEGMENTS);
                distJoint.frequency = 5;
                distJoint.space = FlxNapeSpace.space;
            }
            
            body1 = circle;
            anchor1 = body1.localCOM;
            joints.push(distJoint);
        }
        
        distJoint = new DistanceJoint(body1, hook.body, body1.localCOM, offset_hook.add(hook.body.localCOM), 0, MAX_LENGTH / NUM_SEGMENTS);
        distJoint.frequency = 5;
        distJoint.space = FlxNapeSpace.space;
        joints.push(distJoint);
        
        // apply an impulse to the hook to set it flying
        hook.body.applyImpulse(new Vec2(xvec, yvec));
        
        is_active = true;
    }
    
    public function crank_on_line() {
        // apply an upward impulse on the fishing pole body
        new_cast = false;
        is_cranking = true;
        is_active = false;
        
        hook.body.applyImpulse(new Vec2(0, -1000));
        
        destroy_timer = new FlxTimer();
        destroy_timer.start(1.5).onComplete = function(t:FlxTimer):Void {
            destroy_line();
        }
    }
    
    public function move_hook(force:Vec2) {
        if (is_active) {
            hook.body.applyImpulse(force);
        }
    }
    
    public function destroy_line() {
        hook.visible = false;
        is_cranking = false;
        
    }
    
    function set_pole_position() {
        
        var boat1 = Reg.gamestate.boat1;
        
        pole.body.position.x = boat1.x + 64;
        pole.body.position.y = boat1.y + 32;
        
        var new_angle:Float = 34 - boat1.angle;
        
        pole.body.position.x += 48 * Math.cos(new_angle * Math.PI / 180);
        pole.body.position.y += -48 * Math.sin(new_angle * Math.PI / 180);
        
        var new_anchor:Vec2 = new Vec2(0,0);
        new_anchor.x = boat1.x + 64;
        new_anchor.y = boat1.y + 32;
        var new_angle:Float = 34 - boat1.angle;
        new_anchor.x += 48 * Math.cos(new_angle * Math.PI / 180);
        new_anchor.y += -48 * Math.sin(new_angle * Math.PI / 180);
        
        if (polejoint != null) {
            polejoint.anchor1 = new_anchor;
        }
    }
    
    function draw_line() {
        var from:Vec2;
        var to:Vec2;
        var gfx:Graphics = FlxSpriteUtil.flashGfxSprite.graphics;
        gfx.lineStyle(1, 0x8);
                
        for (joint in joints) {
            from = joint.body1.localPointToWorld(joint.anchor1);
            to = joint.body2.localPointToWorld(joint.anchor2);
            gfx.moveTo(from.x, from.y - Reg.gamestate.camera_target.y + 180);
            gfx.lineTo(to.x, to.y  - Reg.gamestate.camera_target.y + 180);
        }
    }
    
    public function update() {
                
        lineSprite.visible = is_active;
        
        set_pole_position();
        
        if (pre_cast) {
            reset_hook();
        }
        
        if (new_cast) {
            // when the hook hits the water, slow it down
            if (hook.body.position.y > 340) {
                // apply a small force to slow things down
                var newforce:Vec2 = new Vec2(0,0);
                newforce.x = hook.body.velocity.x * -0.1;
                newforce.y = hook.body.velocity.y * -0.03;
                hook.body.applyImpulse(newforce);
            }
        }
        
        /*
        cosmetic_hook.x = hook.x;
        cosmetic_hook.y = hook.y;
        cosmetic_hook.angle = hook.angle;
        */
        
        if (is_active) {
            draw_line();
            var gfx:Graphics = FlxSpriteUtil.flashGfxSprite.graphics;
            gfx.clear();
            draw_line();
            
            lineSprite.pixels.fillRect(new Rectangle(0,0,FlxG.width, FlxG.height), 0x0);
            FlxSpriteUtil.updateSpriteGraphic(lineSprite);
            
            lineSprite.y = Reg.gamestate.camera_target.y - 180;
        }
        
    }
    
}
