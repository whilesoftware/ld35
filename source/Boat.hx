package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import lime.math.Vector2;
import flixel.tweens.FlxEase;

class Boat extends FlxSprite {
    
    var boat_id:Int = 0;
    
    var is_front:Bool = true;
    
    public function new(bid:Int, _is_front:Bool) {
        super();
        
        boat_id = bid;
        is_front = _is_front;
        
        var flipx:Bool = false;
        if (boat_id == 1) {
            flipx = true;
        }

        loadGraphic("assets/images/boat.png", true, 128, 64, true);
        if (is_front) {
            animation.add("a", [6, 7, 8, 9, 10, 11], 3, true, flipx, false);
        }else{
            
            animation.add("a", [0, 1, 2, 3, 4, 5], 3, true, flipx, false);
        }
        
        antialiasing = true;
        
        
        if (boat_id == 1) {
            animation.play("a", false, false, 1);
        }else{
            animation.play("a", false, false, 4);
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

