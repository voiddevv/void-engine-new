function new(){
    frames = Paths.getCharacter("SPARROW",curCharacter);
    animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
    animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
    animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
    animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
    animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

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