package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite {
	public function new(icon:String = "dad",flipX:Bool = false) {
		super();
		loadGraphic(Paths.image('icons/$icon'),true,150,150);
		animation.add("icon",[0,1],0,true,flipX);
		animation.play("icon");

	}
}