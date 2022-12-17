package states.menus;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.effects.FlxFlicker;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxSprite;

class MainMenu extends MusicBeatState
{
	var bg:FlxSprite;
	var bg2:FlxSprite;
	var options:Array<String> = ["story mode", "freeplay", "options"];
	var optionsGroup = new FlxTypedSpriteGroup<FlxSprite>();
	var curItem:Int = 0;
    var issex:Bool = false;

	override function create()
	{
		super.create();
		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music("freakyMenu"));
		bg = new FlxSprite().loadGraphic(Paths.image("menuBG"));
		bg2 = new FlxSprite().loadGraphic(Paths.image("menuBGMagenta"));
		add(bg);
		add(bg2);
		add(optionsGroup);
		bg2.visible = false;
		for (i in 0...options.length)
		{
			var item = new FlxSprite();
			item.frames = Paths.getSparrow('mainMenu/${options[i]}');
			item.animation.addByPrefix("idle", '${options[i]} basic', 24, true);
			item.animation.addByPrefix("selected", '${options[i]} white', true);
			item.y += 160 * i;
			item.antialiasing = true;
			optionsGroup.add(item);
			item.ID = i;
		}
		changeItem();
		optionsGroup.screenCenter(Y);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		for (i in optionsGroup.members)
		{
			i.screenCenter(X);
			i.updateHitbox();
		}
		if (FlxG.keys.justPressed.UP)
			changeItem(-1);
		if (FlxG.keys.justPressed.DOWN)
			changeItem(1);
		if (FlxG.keys.justPressed.ENTER)
			sex();
	}

	function changeItem(a:Int = 0)
	{
        if(issex)
            return;
		FlxG.sound.play(Paths.sound("scrollMenu"));
		curItem += a;
		trace(curItem);
		if (curItem > options.length - 1)
			curItem = 0;
		if (curItem < 0)
			curItem = options.length - 1;
		for (i in optionsGroup.members)
			i.animation.play("idle");
		optionsGroup.members[curItem].animation.play("selected", true);
	}

	function sex()
	{
        if(issex)
            return;
		FlxG.sound.play('assets/sounds/confirmMenu' + ".ogg");
		FlxFlicker.flicker(bg2, 1.1, 0.15, false);
		optionsGroup.forEach(function(spr:FlxSprite)
		{
			if (curItem != spr.ID)
			{
				FlxTween.tween(spr, {alpha: 0}, 0.4, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						spr.kill();
					}
				});
			}
			else
			{
				FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
				{
					var daChoice:String = options[curItem];
					switch (daChoice)
					{
						case 'story mode':
							FlxG.switchState(new StoryMenuState());
						case 'freeplay':
							FlxG.switchState(new FreePlay());
						case 'options':
							FlxG.switchState(new Options());
					}
				});
			}
            issex = true;
		});
	}
}
