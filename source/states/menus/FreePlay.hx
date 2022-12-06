package states.menus;

import flixel.group.FlxSpriteGroup;
import openfl.Assets;
import haxe.Json;
import flixel.FlxSprite;

typedef FreePlayData =
{
	var songs:Array<SongData>;
}

typedef SongData =
{
	var song:String;
	var icon:String;
	var bpm:Float;
	var diffs:Array<String>;
}

class FreePlay extends MusicBeatState
{
	var songGroup = new FlxSpriteGroup();
	var freeplayJson:FreePlayData = Json.parse(Assets.getText(Paths.json("data/freeplaylist")));
	var bg:FlxSprite;
	var songs:Array<String> = [];
	var icons:Array<String> = [];
	var bpms:Array<Float> = [];
	var diffs:Array<String> = ["easy", "normal", "hard"];
	var cursong:Int = 0;
	var curdiff:Int = 1;

	override function create()
	{
		super.create();
		bg = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
		add(bg);
		for (i in freeplayJson.songs)
		{
			songs.push(i.song);
			icons.push(i.icon);
			bpms.push(i.bpm);
            // songGroup.add()
		}
		changeSong(0);
	}

	function changeDiff(a:Int)
	{
		curdiff += a;
		if (curdiff > diffs.length - 1)
			cursong = 0;
		if (cursong < 0)
			curdiff = diffs.length - 1;
	}

	function changeSong(a:Int)
	{
		FlxG.sound.play(Paths.sound("scrollMenu"));
		cursong += a;
		if (cursong > songs.length - 1)
			cursong = 0;
		if (cursong < 0)
			cursong = songs.length - 1;
		diffs = freeplayJson.songs[cursong].diffs;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.LEFT)
			changeDiff(-1);
		if (FlxG.keys.justPressed.RIGHT)
			changeDiff(1);
		if (FlxG.keys.justPressed.DOWN)
			changeSong(1);
		if (FlxG.keys.justPressed.UP)
			changeSong(-1);
	}
}
