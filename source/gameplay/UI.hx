package gameplay;

import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.ui.FlxBar;
import flixel.group.FlxSpriteGroup;

class UI extends FlxSpriteGroup
{
	public var game = GamePlay.instance;

	public static var instance:UI;

	public var playerStrum = new StrumLine();
	public var dadStrum = new StrumLine();
	public var healthBarBg:FlxSprite = new FlxSprite(0, FlxG.height * 0.9);
	public var healthBar:FlxBar;
	public var dadIcon = new HealthIcon('dad');
	public var bfIcon = new HealthIcon('bf', true);

	public function new()
	{
		super();
		instance = this;
		add(playerStrum);
		playerStrum.screenCenter(X);
		add(dadStrum);
		dadStrum.screenCenter(X);
		dadStrum.x -= 350;
		playerStrum.x += 350;
		healthBarBg.loadGraphic(Paths.image("healthBar"));
		healthBarBg.screenCenter(X);
		healthBar = new FlxBar(0, FlxG.height * 0.9 + 4, RIGHT_TO_LEFT, Std.int(instance.healthBarBg.width - 8), Std.int(instance.healthBarBg.height - 8),
			game, "health", 0.0, 2.0);
		add(healthBarBg);
		add(healthBar);
		healthBar.createFilledBar(FlxColor.fromString("0xa344f1"), FlxColor.fromString("0x00c3ff"));
		healthBar.x = healthBarBg.x + 4;
		add(dadIcon);
		add(bfIcon);
        bfIcon.y = dadIcon.y = FlxG.height*0.8;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		dadIcon.scale.set(CoolUtil.lerp(dadIcon.scale.x, 1, 0.2), CoolUtil.lerp(dadIcon.scale.y, 1, 0.2));
		bfIcon.scale.set(CoolUtil.lerp(bfIcon.scale.x, 1, 0.2), CoolUtil.lerp(bfIcon.scale.y, 1, 0.2));

		dadIcon.updateHitbox();
		bfIcon.updateHitbox();

		var iconOffset:Int = 26;
		bfIcon.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		dadIcon.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (dadIcon.width - iconOffset);
	}
    public function iconBump() {
        dadIcon.scale.set(1.2,1.2);
        bfIcon.scale.set(1.2,1.2);
    }
}
