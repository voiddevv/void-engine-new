package engine;

import haxe.Timer;
import openfl.display.FPS;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import external.memory.Memory;

/**

	* FPS class extension to display memory usage.

	* @author Kirill Poletaev

 */
class FPS extends TextField
{
	private var times:Array<Float>;

	private var memPeak:Float = 0;

	public function new(inX:Float = 10.0, inY:Float = 10.0, inCol:Int = 0x000000)
	{
		super();

		x = inX;

		y = inY;

		selectable = false;

		defaultTextFormat = new TextFormat(Paths.font("vcr.ttf"), 18, inCol);

		text = "FPS: ";

		times = [];

		addEventListener(Event.ENTER_FRAME, onEnter);

		autoSize = LEFT;
	}

	private function onEnter(_)
	{
		var now = Timer.stamp();

		times.push(now);

		while (times[0] < now - 1)
			times.shift();

		var mem:Float = Math.round(Memory.getCurrentUsage() / 1024 / 1024 * 100) / 100;

		if (mem > memPeak)
			memPeak = mem;

		if (visible)
		{
			text = "FPS: " + times.length + "\nMEM: " + mem + " MB\nMEM peak: " + memPeak + " MB";
		}
	}
}
