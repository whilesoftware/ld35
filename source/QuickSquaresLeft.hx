package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;

/**
 * ...
 * @author while(software)
 */
class QuickSquaresLeft extends FlxState
{
	var frame:Int;

	var squares:Array<FlxSprite>;
	var square_size = 16;

	var square_count_x = 0;
	var square_count_y = 0;

	var bgcolor_timeline:Timeline;
	var bgposition_timeline:Timeline;
	var bg:FlxSprite;


	private function fill_area(_startx:Int, _starty:Int, _width:Int, _height:Int, _color:Int) {
		for(y in _starty..._starty + _height) {
			for(x in _startx..._width) {
				squares[y * _width + x].makeGraphic(square_size, square_size, _color);
			}
		}
	}
	
	override public function create():Void {
		frame = -1;

		FlxG.mouse.visible = false;
		FlxG.camera.bgColor = 0xff00a287;
		
		bg = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		MathHelper.CenterSprite(bg,"xy");
		add(bg);

		// create a grid of FlxSprites to cover the screen
		squares = new Array<FlxSprite>();
		square_count_x = Std.int(FlxG.width / square_size);
		square_count_y = Std.int(FlxG.height / square_size);
		for(y in 0...square_count_y) {
			for(x in 0...square_count_x) {
				var square:FlxSprite = new FlxSprite();
				square.makeGraphic(square_size, square_size, 0xFF888888);
				square.x = x * square_size;
				square.y = y * square_size;
				//add(square);
				squares.push(square);
			}
		}

		// starts off all black (all squares)
		fill_area(0,0,square_count_x, square_count_y, FlxColor.BLACK);

		// fades in to darkish grey as slower black flyers start to move right to left
		bgcolor_timeline = new Timeline();
		bgcolor_timeline.type = TimeNodeType.color;
		bgcolor_timeline.nodes.push(new TimeNode(0 , FlxColorUtil.getColor32(255,0,0,0), FlxEase.bounceIn));
		bgcolor_timeline.nodes.push(new TimeNode(120, FlxColorUtil.getColor32(255,255,255,255), FlxEase.bounceIn));

		// faster lighter grey flyers start coming in

		// speed and rate picks up very fast

		// while(software) flahes in time with some musical trigger

		// fades out to configurable color (target bgcolor of whatever the next state (menu?) is coming next)

		
		//for(p in 0...squares.length) {
		//	squares[p].makeGraphic(square_size, square_size, p % 3 > 0 ? 0xFF777777:0xFF999999);
		//}
	
/*	
		new FlxTimer().start(0.5).onComplete = function(t:FlxTimer):Void
		{
			var circle:FlxSprite = new FlxSprite();
			circle.makeGraphic(FlxG.height, FlxG.height, 0x00FFFFFF);
			circle.screenCenter();
			FlxSpriteUtil.drawCircle(circle, -1, -1, 0, 0xFF004e61);
			circle.scale.set();
			add(circle);
			new FlxTimer().start(0.5).onComplete = function(t:FlxTimer):Void
			{
				FlxTween.tween(circle.scale, { x:2.5, y:2.5 }, 0.4).onComplete = function(t:FlxTween):Void { bg.kill(); }
							FlxG.camera.fade(Reg.colors[1], 0.2);
							new FlxTimer().start(0.2).onComplete = function(t:FlxTimer):Void { FlxG.switchState(new NewMenuState()); } 
						}
					}
				}
			}
		}
*/
	}

	//override public function update(elapsed:Float):Void {
	override public function update():Void {
		frame++;

		// update bgcolor
		var new_color:Int = bgcolor_timeline.value(frame);
		bg.makeGraphic(FlxG.width, FlxG.height, new_color);

		// update while(software) text
		
		// update object positions

		// reset square values to zero

		// "render" object positions onto square grid values

		// map grid values to square colors
	}
}
