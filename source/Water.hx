package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import lime.math.Vector2;
import flixel.tweens.FlxEase;

class Water extends FlxSprite {
    public function new() {
        super();
        
        var flipx:Bool = FlxG.random.float() > 0.5;
        var flipy:Bool = FlxG.random.float() > 0.5;

        loadGraphic("assets/images/water.png", true, 640, 64, true);
        animation.add("a", [0, 1, 2, 3, 4], FlxG.random.int(2,5), true, flipx, flipy);
        animation.add("b", [5, 6, 7, 8, 9], FlxG.random.int(2,5), true, flipx, flipy);
        
        randomize(false);
    }
    
    private function randomize(outside:Bool) {
        y = FlxG.random.int(0, Std.int(FlxG.height / 3));
        y = FlxG.height - 64 + FlxG.random.int(-20, 30);
        
        if (outside) {
            x = FlxG.random.int(-700, -650);
        }else{
            x = FlxG.random.int(-640, FlxG.width);
        }
        
        if (FlxG.random.float() < 0.5) {
            animation.play("a", false, false, FlxG.random.int(0, 4));
        }else{
            animation.play("b", false, false, FlxG.random.int(0, 4));
        }
        
        velocity.set( FlxG.random.float(25, 55), 0);
    }
    
    public override function update(elapsed:Float) {
        super.update(elapsed);
        
        // did we get too far to the right?
        if (x >= FlxG.width) {
            randomize(true);
        }
        
    }
}

