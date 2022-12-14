package subStates;

import flixel.system.FlxSound;
import flixel.FlxSprite;
import gameplay.GamePlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

class Pause extends MusicBeatSubstate
{
	/**List of menu options**/
	var options:Array<String> = ['Resume', 'Restart Song','Skip Time', 'Exit to menu'];
	var curOption:Int = 0;
	var optionsGroup = new FlxTypedGroup<Alphabet>();
	var menuMusic:FlxSound;
	override function create()
	{
		super.create();
		menuMusic = new FlxSound().loadEmbedded(Paths.music("breakfast"), true);
		FlxG.sound.list.add(menuMusic);
		menuMusic.volume = 0;
		menuMusic.fadeIn();
		menuMusic.play(true);
		var bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		add(bg);

		cameras = [GamePlay.instance.camHUD];
		for (i in 0...options.length)
		{
			var text = new Alphabet(0, 0, options[i], true);
			text.isMenuItem = true;
			text.targetY = i;
			optionsGroup.add(text);
		}
		add(optionsGroup);
		changeItem();
	}
	/**Closes the pause menu**/
	override function close()
	{
		menuMusic.stop();
		GamePlay.paused = false;
		GamePlay.instance.voices.resume();
		FlxG.sound.music.play();
		GamePlay.instance.syncAudio();
		super.close();
	}
	/**changes the current oprion**/
	function changeItem(a:Int = 0)
	{
		FlxG.sound.play(Paths.sound("scrollMenu"));
		curOption += a;
		if (curOption > options.length - 1)
			curOption = 0;
		if (curOption < 0)
			curOption = options.length - 1;
		var why:Int = 0;
		for (item in optionsGroup.members)
		{
			item.targetY = why - curOption;
			why++;
			item.alpha = 0.6;
			if (item.targetY == 0)
				item.alpha = 1;
		}
	}
	/**SEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEX**/
	function sex(a:Int)
	{
		switch (a)
		{
			case 0:
				close();
			case 1:
				FlxG.resetState();
			case 2:
				var time = 60*1000;
				GamePlay.instance.voices.time = time;
				FlxG.sound.music.time = time;
				Conductor.songPosition = time;
				close();
			case 3:
				FlxG.switchState(new MainMenu());
                menuMusic.stop();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER)
			sex(curOption);
		if (FlxG.keys.justPressed.DOWN)
			changeItem(1);
		if (FlxG.keys.justPressed.UP)
			changeItem(-1);
	}
}
