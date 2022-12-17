package states.menus;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Assets;
import flixel.effects.FlxFlicker;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxSave;

class Options extends MusicBeatState
{
	var bg:FlxSprite;
	var options = ["GamePlay", "Controls", "Misc"];
	var optionsGroup = new FlxTypedSpriteGroup();
	var curOption:Int = 0;
	var sexing:Bool = false;

	override function create()
	{
		super.create();
		bg = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
		bg.color = 0xAD190170;
		add(bg);
		for (i in 0...options.length)
		{
			var item = new Alphabet(0, 0, options[i], true);
			item.y += 120 * i;
			item.screenCenter(X);
			item.ID = i;
			optionsGroup.add(item);
		}
		add(optionsGroup);
		optionsGroup.screenCenter(Y);
		changeOption();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.DOWN)
			changeOption(1);
		if (FlxG.keys.justPressed.UP)
			changeOption(-1);
		if (FlxG.keys.justPressed.ENTER)
			sex();
	}

	function changeOption(a:Int = 0)
	{
		if (sexing)
			return;
        FlxG.sound.play(Paths.sound("scrollMenu"));
		curOption += a;
		if (curOption > options.length - 1)
			curOption = 0;
		if (curOption < 0)
			curOption = options.length - 1;
		optionsGroup.forEach(function(item:Alphabet)
		{
			if (curOption != item.ID)
				item.alpha = 0.6;
			else
				item.alpha = 1;
		});
	}

	function sex()
	{
		if (sexing)
			return;
		FlxG.sound.play(Paths.sound("confirmMenu"));
		optionsGroup.forEach(function(item)
		{
            if(item.ID!= curOption)
                FlxTween.tween(item,{alpha:0},0.6,{ease: FlxEase.circOut});
            FlxTween.tween(item,{y:-100},1,{ease: FlxEase.expoIn});
			FlxFlicker.flicker(item, 1, 0.06, true, true, function(a)
			{
				switch (options[curOption])
				{
					case("GamePlay"):
						trace("going to gamePlya settings");
				}
			});
		});

		sexing = true;
	}
}
