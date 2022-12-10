function new(){
    frames = Paths.getCharacter("SPARROW",curCharacter);
    icon = "spooky";
    barColor = "0xd57e00";
    danceSteps = ["danceLeft","danceRight"];
    animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
    animation.addByPrefix('singLEFT', 'note sing left', 24, false);
    animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
    animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
    animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
    animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

    addOffset('danceLeft');
    addOffset('danceRight');

    addOffset("singUP", -20, 26);
    addOffset("singRIGHT", -130, -14);
    addOffset("singLEFT", 130, -10);
    addOffset("singDOWN", -50, -130);

    playAnim('danceRight');
}