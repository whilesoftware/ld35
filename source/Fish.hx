package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import lime.math.Vector2;
import flixel.tweens.FlxEase;

class Fish extends FlxSprite {
    
    var swing_rate:Int;
    
    var swing_time:Int = 0;
    
    var swing_state:String = "a";
    
    var state:Int = 0;
    // 0 = swimming
    // 1 = hooked
    
    
    public function new() {
        super();
        
        loadGraphic("assets/images/fish.png", true, 64, 64, true);
        
        animation.add("a_left", [ 0, 1, 2, 3], FlxG.random.int(3,6), true, false, false);
        animation.add("a_right", [ 0, 1, 2, 3], FlxG.random.int(3,6), true, true, false);
        
        animation.add("b_left", [ 4, 5, 6, 7], FlxG.random.int(3,6), true, false, false);
        animation.add("b_right", [ 4, 5, 6, 7], FlxG.random.int(3,6), true, true, false);
        
        randomize();
    }
    
    private function randomize() {
        
        state = 0;
        
        y = FlxG.random.int(420, 640);
        
        if (FlxG.random.float() < 0.5) {
            // moving right to left
            x = FlxG.random.int(FlxG.width + 200, FlxG.width + 100);
            velocity.x = FlxG.random.float(-100, -300);
            
        }else{
            // moving left to right
            x = FlxG.random.int(-200, -100);
            velocity.x = FlxG.random.float(100, 300);
        }
        
        swing_rate = FlxG.random.int(10,30);
        swing_time = 0;
    }
    
    public function hook_fish() {
        // switch to the hooked state
        // fly up in the air
    }
    
    public override function update(elapsed:Float) {
        super.update(elapsed);
        
        // did we get too far to the right?
        if (state == 0) {
            
            // is it time to swing to the other position?
            if (swing_time <= Reg.frame_number) {
                if (swing_state == "a") {
                    swing_state = "b";
                }else{
                    swing_state = "a";
                }
                
                if (velocity.x > 0) {
                    animation.play(swing_state + "_right");
                }else{
                    animation.play(swing_state + "_left");
                }
                
                swing_time = Reg.frame_number + swing_rate;
            }
            
            if (velocity.x > 0 && x >= FlxG.width) {
                randomize();
            }
            
            if (velocity.x < 0 && x < -64) {
                randomize();
            }
            
        }else{
            // if we get above a y = 300, turn into a bird and randomize
        }
    }
}

