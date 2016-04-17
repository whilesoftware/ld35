package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import lime.math.Vector2;
import flixel.tweens.FlxEase;

class Oar extends FlxSprite {
    
    var reversed:Bool = false;
    
    public function set_reversed(newval:Bool) {
        reversed = newval;
    }
    
    public function new() {
        super();
        
        antialiasing = true;

        loadGraphic("assets/images/mock-char.png", true, 128, 64, true);
                
        animation.add("rowing", [22, 23, 19, 18, 17, 16, 20, 21], 5, true, false, false);
        animation.add("r_rowing", [22, 23, 19, 18, 17, 16, 20, 21], 5, true, true, false);
    }
    
    public function start_rowing() {
        visible = true;
        if (reversed) {
            animation.play("r_rowing", true, false, 0);
        }else{
            animation.play("rowing", true, false, 0);
        }
        
    }
    
    public function stop_rowing() {
        visible = false;
        animation.stop();
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



