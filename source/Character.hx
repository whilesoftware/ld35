package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import lime.math.Vector2;
import flixel.tweens.FlxEase;

import flixel.util.FlxTimer;

class Character extends FlxSprite {
    
    var boat_id:Int = 0;
    
    public var is_fishing:Bool = false;
    
    public function new(bid:Int) {
        super();
        
        boat_id = bid;
        
        var flipx:Bool = false;
        if (boat_id == 1) {
            flipx = true;
        }
        
        antialiasing = true;

        loadGraphic("assets/images/mock-char.png", true, 128, 64, true);
        
        animation.add("fish_sit", [0, 1, 2, 3], 3, true, flipx, false);
        animation.add("fish_stand", [4, 5, 6, 7], 3, true, flipx, false);
        
        animation.add("rowing", [14, 15, 11, 10, 9, 8, 12, 13], 5, true, flipx, false);
        
        animation.add("fish_precast_standing", [24], 1, true, flipx, false);
        animation.add("fish_cast_standing", [25, 26], 10, false, flipx, false);
        animation.add("fish_crank_standing", [27, 28, 29], 10, true, flipx, false);
        
        animation.play("fish_sit", false, false, -1);
    }
    
    public function start_rowing() {
        animation.play("rowing", true, false, 0);
    }
    
    public function stop_rowing() {
        animation.play("fish_sit", true, false, 0);
    }
    
    public function start_casting() {
        is_fishing = false;
        animation.play("fish_precast_standing", true, false, 0);
        
        Reg.gamestate.player_line.precast();
        
        new FlxTimer().start(0.2).onComplete = function(t:FlxTimer):Void
        {
            Reg.gamestate.player_line.cast_new_line(250, -150);
            animation.play("fish_cast_standing", true, false, 0);
            
            new FlxTimer().start(1).onComplete = function(t:FlxTimer):Void {
                is_fishing = true;
                animation.play("fish_stand", true, false, 0);
            }
        }
    }
    
    public function start_cranking() {
        animation.play("fish_crank_standing", true, false, 0);
        
        new FlxTimer().start(0.2).onComplete = function(t:FlxTimer):Void
        {
            Reg.gamestate.player_line.crank_on_line();
            animation.play("fish_stand", true, false, 0);
            is_fishing = false;
        }
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


