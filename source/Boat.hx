package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import lime.math.Vector2;
import flixel.tweens.FlxEase;

class Boat extends FlxSprite {
    
    var boat_id:Int = 0;
    
    public function new(bid:Int) {
        super();
        
        boat_id = bid;
        
        var flipx:Bool = false;
        if (boat_id == 1) {
            flipx = true;
        }

        loadGraphic("assets/images/boat.png", true, 128, 64, true);
        animation.add("a", [0, 1, 2, 3, 4, 5], 3, true, flipx, false);
        
        if (boat_id == 1) {
            x = 64;
        }else{
            x = FlxG.width - 128 - 64;
        }
        
        x += FlxG.random.int(-5, 5);
        y = FlxG.random.int(FlxG.height - 80, FlxG.height - 70);
        
        animation.play("a", false, false, -1);
    }
    
    public override function update(elapsed:Float) {
        super.update(elapsed);
        
    }
}

