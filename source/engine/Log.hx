package engine;

import openfl.text.TextFormat;
import openfl.events.Event;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.display.Sprite;
import openfl.text.TextField;

class Log extends Sprite
{
    var logText = new TextField();
	public var opened:Bool = false;
    public var totalLogs:Int = 0;

	public function new()
	{
		super();
		y = 100;
		x = 10;
		alpha = 0;
        addChild(logText);
        logText.defaultTextFormat = new TextFormat(Paths.font("vcr.ttf"),18,0xFFFFFFFF);
	}

	public function open()
	{
		trace("hello logs");
		FlxTween.tween(this, {alpha: 1}, 0.5, {ease: FlxEase.cubeIn});
		stage.alpha = 0.6;
		trace(FlxG.camera.bgColor.alpha);
	}

	public function clear()
	{
		logText.text = "";
        totalLogs = 0;
	}

	public function add(value:Dynamic)
	{
		logText.text += value + "\n";
        totalLogs ++;
	}
    public function error(value:Dynamic) {
        logText.textColor = 0xFFFF0000;
        logText.text += "[ERROR] " + value + "\n";

    }

	public function close()
	{
		trace("good bye logs");
		FlxTween.tween(this, {alpha: 0}, 0.5, {ease: FlxEase.cubeIn});
		trace(FlxG.camera.bgColor.alpha);
		stage.alpha = 1;
	}
}
