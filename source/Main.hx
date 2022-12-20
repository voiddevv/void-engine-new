package;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import engine.Log;
import engine.FPS;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var logs = new Log();

	public function new()
	{
		super();
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHit);
		addChild(new FlxGame(0, 0, Intro, 1000, 1000, true));
		FlxG.fixedTimestep = false;
		addChild(new FPS(10, 3, 0xffffff));
		addChild(logs);
	}

	public function keyHit(event:KeyboardEvent)
	{
		switch (event.keyCode)
		{
			case Keyboard.F6:
				if (logs.opened)
					logs.open();
				else
					logs.close();
				logs.opened = !logs.opened;
			case Keyboard.F5:
				FlxG.resetState();
		}
	}
}
