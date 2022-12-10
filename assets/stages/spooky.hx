function new(){
    var hallowTex = Paths.getSparrow("stages/spooky house/bg");
    halloweenBG = new FlxSprite(-200, -100);
    halloweenBG.frames = hallowTex;
    halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
    halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
    halloweenBG.animation.play('idle');
    halloweenBG.antialiasing = true;
    add(halloweenBG);
    dad.y += 175;
    dad.x += 25;
}