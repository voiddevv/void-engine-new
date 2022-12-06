function new(){
    camoffset = [0,-150];
    frames = Paths.getCharacter("SPARROW",curCharacter);
    animation.addByPrefix('idle', 'Dad idle dance', 24,false);
    animation.addByPrefix('singUP', 'Dad Sing Note UP', 24,false);
    animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24,false);
    animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24,false);
    animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24,false);

    addOffset('idle');
    addOffset("singUP", -6, 50);
    addOffset("singRIGHT", 0, 27);
    addOffset("singLEFT", -10, 10);
    addOffset("singDOWN", 0, -30);

    playAnim('idle');
}