package gameplay;

import scripting.Hscript;
import flixel.group.FlxSpriteGroup;

class Stage extends FlxSpriteGroup
{
	public var script = new Hscript();
	public var camZoom = 1.05;

	public function new(stage:String = 'stage')
	{
		super();
		if (GamePlay.instance != null)
		{
			script.interp.variables.set("gf", GamePlay.instance.gf);
			script.interp.variables.set("dad", GamePlay.instance.dad);
			script.interp.variables.set("bf", GamePlay.instance.bf);
		}
		script.interp.scriptObject = this;
		try
		{
			script.loadScript('stages/$stage');
		}
		catch (e)
		{
			trace(e.details());
			script.loadScript('stages/stage');
		}
		script.call("new");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		script.call("update", [elapsed]);
	}
}
