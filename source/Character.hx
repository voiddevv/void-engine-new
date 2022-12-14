package;

import flixel.math.FlxMath;
import hscript.Expr.Error;
import openfl.display.JointStyle;
import openfl.display.Window;
import flixel.input.FlxInput;
import haxe.io.Input;
import haxe.Json;
import openfl.Assets;
import flixel.util.FlxColor;
import engine.objects.Sprite;
import flixel.util.FlxTimer;
import scripting.Hscript;
import flixel.FlxSprite;

using StringTools;

typedef CharacterJson =
{
	var type:String;
	var icon:String;
	var barColor:String;
	var singDur:Float;
	var danceSteps:Array<String>;
	var camOffsets:Array<Int>;
	var anims:Array<AnimData>;
	var antialiasing:Bool;
	var globalOffset:Array<Float>;
}

typedef AnimData =
{
	var name:String;
	var nameInXml:String;
	var frameRate:Int;
	var indices:Array<Int>;
	var looped:Bool;
	var offsets:Array<Float>;
}

class Character extends Sprite
{
	public var json:CharacterJson;
	public var script = new Hscript();
	public var curCharacter:String = '';
	public var canDance:Bool = true;
	public var danceSteps:Array<String> = ["idle"];
	public var curDance:Int = 0;
	public var holdTimer:Float = 0.0;
	public var debugMode:Bool = false;
	public var icon:String = "dad";
	public var barColor:String = "0xaf66ce";
	public var camOffset:Array<Int> = [0, 0];
	public var singDur:Float = 4.0;

	public function new(x:Float, y:Float, character:String)
	{
		super(x, y);

		this.curCharacter = character;
		try
		{
			json = Json.parse(Assets.getText(Paths.json('images/characters/$curCharacter/character')));
		}
		catch(e){
			FlxG.log.warn(e);
			json = Json.parse(Assets.getText(Paths.json('images/characters/dad/character')));
		}
		script.interp.scriptObject = this;
		try
		{
			script.loadScript('images/characters/$curCharacter/character');
		}
		catch (e)
		{
			FlxG.log.error(e);
		}
		script.call("new");
		dance();
	}

	public function changeCharacter(newCharacter:String)
	{
		this.curCharacter = newCharacter;
		script.interp.scriptObject = this;
		try
		{
			script.loadScript('images/characters/$curCharacter/character');
		}
		catch (e)
		{
			FlxG.log.error(e);
		}
		script.call("new");
	}

	public function playAnim(anim:String, force:Bool = false, time:Float = 0.0, frame:Int = 0)
	{
		if (json.globalOffset == null)
			json.globalOffset = [0.0, 0.0];
		var daOffset = animOffsets.get(anim);
		if (animOffsets.exists(anim))
		{
			offset.set(daOffset[0] + json.globalOffset[0], daOffset[1] + json.globalOffset[1]);
		}
		animation.play(anim, force, false, frame);
	}

	override function update(elapsed:Float)
	{
		if (!debugMode)
		{
			if (animation.curAnim != null && animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}
			else
				holdTimer = 0;

			if (animation.curAnim != null && animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode)
			{
				playAnim('idle', true, 1.0, 10);
			}

			if (animation.curAnim != null && animation.curAnim.name == 'firstDeath' && animation.curAnim.finished)
			{
				playAnim('deathLoop');
			}
		}
		super.update(elapsed);
	}

	public function dance()
	{
		playAnim(danceSteps[curDance]);
		curDance++;
		if (curDance > danceSteps.length - 1)
			curDance = 0;
	}

	/**loads and parses json**/
	public function load()
	{
		try
		{
			if (json.type == null)
				json.type = "SPARROW";
			FlxG.log.add(json.type);
			frames = Paths.getCharacter(json.type, curCharacter);
			antialiasing = json.antialiasing;
			icon = json.icon;
			barColor = json.barColor;
			camOffset = json.camOffsets;
			for (anim in json.anims)
			{
				if (anim.indices != null)
					animation.addByIndices(anim.name, anim.nameInXml, anim.indices, "", anim.frameRate, anim.looped);
				else
					animation.addByPrefix(anim.name, anim.nameInXml, anim.frameRate, anim.looped);
				addOffset(anim.name, anim.offsets[0], anim.offsets[1]);
			}
		}
		catch (e)
		{
			FlxG.log.error(e);
		}
	}
}
