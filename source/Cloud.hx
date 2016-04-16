package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import lime.math.Vector2;
import flixel.tweens.FlxEase;

class Cloud extends FlxSprite {
    public function new() {
        super();
        
        var flipx:Bool = FlxG.random.float() > 0.5;
        var flipy:Bool = FlxG.random.float() > 0.5;

        loadGraphic("assets/images/clouds.png", true, 128, 64, true);
        animation.add("a", [0, 1, 2, 3, 4], FlxG.random.int(2,4), true, flipx, flipy);
        animation.add("b", [5, 6, 7, 8, 9], FlxG.random.int(2,4), true, flipx, flipy);
        animation.add("c", [10, 11, 12, 13, 14], FlxG.random.int(2,4), true, flipx, flipy);
        
        randomize(false);
    }
    
    private function randomize(outside:Bool) {
        y = FlxG.random.int(0, Std.int(FlxG.height / 3));
        
        if (outside) {
            x = FlxG.random.int(-300, -200);
        }else{
            x = FlxG.random.int(0, FlxG.width);
        }
        
        if (FlxG.random.float() < 0.334) {
            animation.play("a", false, false, FlxG.random.int(0, 4));
        }else {
            if (FlxG.random.float() < 0.5) {
                animation.play("b", false, false, FlxG.random.int(0, 4));
            }else{
                animation.play("c", false, false, FlxG.random.int(0, 4));
            }
        }
        
        velocity.set( FlxG.random.float(1, 15), 0);
    }
    
    public override function update(elapsed:Float) {
        super.update(elapsed);
        
        // did we get too far to the right?
        if (x >= FlxG.width) {
            randomize(true);
        }
        
    }
}

