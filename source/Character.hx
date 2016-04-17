package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import lime.math.Vector2;
import flixel.tweens.FlxEase;

import flixel.util.FlxTimer;

import nape.geom.Vec2;

class Character extends FlxSprite {
    
    public var is_fishing:Bool = false;
    
    var reversed:Bool = false;
    var prefix:String = "";
    
    public function set_reversed(newval:Bool) {
        reversed = newval;
        if (reversed) {
            prefix="r_";
        }else{
            prefix = "";
        }
    }
    
    public function load_animations(flipx:Bool, _prefix:String) {
        animation.add(_prefix + "fish_sit", [0, 1, 2, 3], 3, true, flipx, false);
        animation.add(_prefix + "fish_stand", [4, 5, 6, 7], 3, true, flipx, false);
        animation.add(_prefix + "rowing", [14, 15, 11, 10, 9, 8, 12, 13], 5, true, flipx, false);
        animation.add(_prefix + "fish_precast_standing", [24], 1, true, flipx, false);
        animation.add(_prefix + "fish_cast_standing", [25, 26], 10, false, flipx, false);
        animation.add(_prefix + "fish_crank_standing", [27, 28, 29], 10, true, flipx, false);
    }
    
    public function new(bid:Int) {
        super();
        
        loadGraphic("assets/images/mock-char.png", true, 128, 64, true);
        load_animations(false, "");
        load_animations(true, "r_");
        
        antialiasing = true;
        
        stop_rowing();
    }
    
    public function start_rowing() {
        animation.play(prefix + "rowing", true, false, 0);
    }
    
    public function stop_rowing() {
        animation.play(prefix + "fish_sit", true, false, 0);
    }
    
    public function start_casting() {
        is_fishing = false;
        animation.play(prefix + "fish_precast_standing", true, false, 0);
        
        Reg.gamestate.player_line.precast();
        
        new FlxTimer().start(0.2).onComplete = function(t:FlxTimer):Void
        {
            Reg.gamestate.player_line.cast_new_line(250, -150);
            animation.play(prefix + "fish_cast_standing", true, false, 0);
            
            new FlxTimer().start(1).onComplete = function(t:FlxTimer):Void {
                is_fishing = true;
                animation.play(prefix + "fish_stand", true, false, 0);
            }
        }
    }
    
    public function start_cranking() {
        animation.play(prefix + "fish_crank_standing", true, false, 0);
        
        new FlxTimer().start(0.2).onComplete = function(t:FlxTimer):Void
        {
            Reg.gamestate.player_line.crank_on_line();
            animation.play(prefix + "fish_stand", true, false, 0);
            is_fishing = false;
        }
    }
    
    public function move_hook(force:Vec2) {
        Reg.gamestate.player_line.move_hook(force);
    }
    
    public function set(data:BoatData) {
        x = data.x;
        y = data.y;
        angle = data.angle;
    }
    
    public override function update(elapsed:Float) {
        super.update(elapsed);
        
    }
}


