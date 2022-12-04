function new(){
    frames = Paths.getCharacter("SPARROW",curCharacter);
    animation.addByPrefix('idle', 'Dad idle dance', 24);
    animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
    animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
    animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
    animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

    addOffset('idle');
    addOffset("singUP", -6, 50);
    addOffset("singRIGHT", 0, 27);
    addOffset("singLEFT", -10, 10);
    addOffset("singDOWN", 0, -30);

    playAnim('idle');
}