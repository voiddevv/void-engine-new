package states.menus.optionsPages;

import flixel.addons.transition.FlxTransitionableState;

class Misc extends MusicBeatState
{
	function new()
	{
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
        super();
	}
}
