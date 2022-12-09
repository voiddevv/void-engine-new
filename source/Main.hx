package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, Intro,1000,1000,true));
		FlxG.fixedTimestep = false;

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end
	}
}
