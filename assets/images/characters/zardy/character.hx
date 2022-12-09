function new(){
    camoffset = [0,-240];
    frames = Paths.getCharacter("SPARROW",curCharacter);
    animation.addByPrefix('idle', 'Idle', 24,false);
    animation.addByPrefix('singUP', 'Sing Up', 24,false);
    animation.addByPrefix('singRIGHT', 'Sing Right', 24,false);
    animation.addByPrefix('singDOWN', 'Sing Down', 24,false);
    animation.addByPrefix('singLEFT', 'Sing Left', 24,false);

    addOffset('idle');
    addOffset("singUP", 0, 0);
    addOffset("singRIGHT", 0, 0);
    addOffset("singLEFT", 0, 0);
    addOffset("singDOWN", 0, 0);

    playAnim('idle');
}