package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import lime.math.Vector2;
import flixel.tweens.FlxEase;

class Boat extends FlxSprite {
    
    var is_front:Bool = true;
    
    var reversed:Bool = false;
    
    public function set_reversed(newval:Bool) {
        reversed = newval;
        
        if (reversed) {
            animation.play("r_a", false, false, 1);
        }else{
            animation.play("a", false, false, 1);
        }
    }
    
    public function new(_is_front:Bool) {
        super();
        
        is_front = _is_front;

        loadGraphic("assets/images/boat.png", true, 128, 64, true);
        if (is_front) {
            animation.add("a", [6, 7, 8, 9, 10, 11], 3, true, false, false);
            animation.add("r_a", [6, 7, 8, 9, 10, 11], 3, true, true, false);
        }else{
            animation.add("a", [0, 1, 2, 3, 4, 5], 3, true, false, false);
            animation.add("r_a", [0, 1, 2, 3, 4, 5], 3, true, true, false);
        }
        
        antialiasing = true;
        
        set_reversed(false);
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

