function stepHit(curStep)
{
    trace(curStep);
	switch (curStep)
	{
		case 2427:
            FlxTween.tween(dad, {alpha: 0.8}, 0.4);
            FlxG.camera.shake(0.05,0.35);
            
        case 2943:
            FlxTween.tween(dad, {alpha: 0.0}, 0.4);

	}
}