package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	public function new(icon:String = "dad", flipX:Bool = false)
	{
		super();
		loadGraphic(Paths.image('icons/$icon'), true, 150, 150);
		animation.add("icon", [0, 1], 0, true, flipX);
		animation.play("icon");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
