package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import lime.math.Vector2;
import flixel.tweens.FlxEase;

class Character extends FlxSprite {
    
    var boat_id:Int = 0;
    
    public function new(bid:Int) {
        super();
        
        boat_id = bid;
        
        var flipx:Bool = false;
        if (boat_id == 1) {
            flipx = true;
        }

        loadGraphic("assets/images/mock-char.png", true, 128, 64, true);
        
        animation.add("fish_sit", [0, 1, 2, 3], 3, true, flipx, false);
        animation.add("fish_stand", [4, 5, 6, 7], 3, true, flipx, false);
        
        animation.add("rowing", [14, 15, 11, 10, 9, 8, 12, 13], 5, true, flipx, false);
        
        animation.play("fish_sit", false, false, -1);
    }
    
    public function start_rowing() {
        animation.play("rowing", true, false, 0);
    }
    
    public function stop_rowing() {
        animation.play("fish_sit", true, false, 0);
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


