package states.menus;

import sys.thread.Thread;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import gameplay.GamePlay;
import flixel.group.FlxGroup.FlxTypedGroup;
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
	var color:String;
}

class FreePlay extends MusicBeatState
{
	var songGroup = new FlxTypedGroup<Alphabet>();
	var iconGroup = new FlxTypedGroup<HealthIcon>();
	var freeplayJson:FreePlayData = Json.parse(Assets.getText(Paths.json("data/freeplaylist")));
	var bg:FlxSprite;
	var songs:Array<String> = [];
	var icons:Array<String> = [];
	var bpms:Array<Float> = [];
	var diffs:Array<String> = ["easy", "normal", "hard"];
	var cursong:Int = 0;
	var curdiff:Int = 1;
	var diffText = new FlxText();
	var musicthr:Thread;

	override function create()
	{
		super.create();

		bg = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
		add(bg);
		for (i in 0...freeplayJson.songs.length)
		{
			// set up for list shit
			songs.push(freeplayJson.songs[i].song);
			icons.push(freeplayJson.songs[i].icon);
			bpms.push(freeplayJson.songs[i].bpm);
			var songText = new Alphabet(0, 30 * i, freeplayJson.songs[i].song, true);
			songText.isMenuItem = true;
			songText.targetY = i;
			songGroup.add(songText);
			var icon = new HealthIcon(icons[i]);
			icon.sprTracker = songText;
			iconGroup.add(icon);
		}

		add(songGroup);
		add(iconGroup);
		var scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		diffText.setPosition(scoreText.x, scoreText.y + 32);
		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 8, 0).makeGraphic(Std.int(FlxG.width * 0.35), Std.int(66 * 1.2), 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);
		scoreText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);
		diffText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		add(diffText);
		changeSong(0);
	}

	function changeDiff(a:Int)
	{
		curdiff += a;
		if (curdiff > diffs.length - 1)
			curdiff = 0;
		if (curdiff < 0)
			curdiff = diffs.length - 1;
		diffText.text = diffs[curdiff];
		GamePlay.chartDiff = diffs[curdiff];
		trace(diffs[curdiff]);
	}

	function sexSong()
	{
		GamePlay.SONG = Song.loadFromJson(diffs[curdiff], songs[cursong]);
		FlxG.sound.music.stop();
		FlxG.switchState(new GamePlay());
	}

	function changeSong(a:Int)
	{
		FlxG.sound.play(Paths.sound("scrollMenu"));
		changeDiff(0);
		cursong += a;
		if (cursong > songs.length - 1)
			cursong = 0;
		if (cursong < 0)
			cursong = songs.length - 1;
		trace(cursong);
		diffs = freeplayJson.songs[cursong].diffs;
		trace(diffs);
		FlxTween.color(bg, 0.45, bg.color, FlxColor.fromString(freeplayJson.songs[cursong].color));
		var musicthr = Thread.create(function()
		{
			FlxG.sound.playMusic(Paths.inst(songs[cursong]));
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		for (i in 0...songGroup.members.length)
			songGroup.members[i].targetY = i - cursong;
		if (FlxG.keys.justPressed.LEFT)
			changeDiff(-1);
		if (FlxG.keys.justPressed.RIGHT)
			changeDiff(1);
		if (FlxG.keys.justPressed.DOWN)
			changeSong(1);
		if (FlxG.keys.justPressed.UP)
			changeSong(-1);
		if (FlxG.keys.justPressed.ENTER)
		{
			try
			{
				sexSong();
			}
			catch (e)
			{
				trace("SONG CHART NOT FOUND ERROR BELOW");
				trace(e.details());
			}
		}
	}
}
