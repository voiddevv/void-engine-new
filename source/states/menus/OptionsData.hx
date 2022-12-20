package states.menus;

class OptionsData
{
	public static var misc = ["FpsCounter" => true];
	public static var controls = ["LEFT" => "D", "DOWN" => "F", "UP" => "J", "RIGHT" => "K"];
	public static var gamePlay = [
		"DownScroll" => false,
		"MiddleScroll" => false,
		"HitSound" => false,
		"BotPlay" => false
	];

	public function new()
	{
		trace("cum balls");
	}
}
