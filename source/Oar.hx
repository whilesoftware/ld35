package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import lime.math.Vector2;
import flixel.tweens.FlxEase;

class Oar extends FlxSprite {
    
    var boat_id:Int = 0;
    
    
    public function new(bid:Int) {
        super();
        
        boat_id = bid;
        
        var flipx:Bool = false;
        if (boat_id == 1) {
            flipx = true;
        }
        
        antialiasing = true;

        loadGraphic("assets/images/mock-char.png", true, 128, 64, true);
                
        animation.add("rowing", [22, 23, 19, 18, 17, 16, 20, 21], 5, true, flipx, false);
    }
    
    public function start_rowing() {
        visible = true;
        animation.play("rowing", true, false, 0);
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



