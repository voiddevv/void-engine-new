function new(){
    frames = Paths.getCharacter("SPARROW",curCharacter);
    animation.addByPrefix('idle', 'Senpai Idle', 24, false);
    animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
    animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
    animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
    animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);
    addOffset('idle');
    addOffset("singUP", 5, 37);
    addOffset("singRIGHT");
    addOffset("singLEFT", 40);
    addOffset("singDOWN", 14);
    playAnim('idle');
    setGraphicSize(Std.int(width * 6));
    updateHitbox();
    antialiasing = false;
}