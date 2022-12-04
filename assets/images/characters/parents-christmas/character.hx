function new(){
    frames = Paths.getCharacter("SPARROW",curCharacter);
    animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
    animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
    animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
    animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
    animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);
    animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);
    animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
    animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
    animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);
    addOffset('idle');
    addOffset("singUP", -47, 24);
    addOffset("singRIGHT", -1, -23);
    addOffset("singLEFT", -30, 16);
    addOffset("singDOWN", -31, -29);
    addOffset("singUP-alt", -47, 24);
    addOffset("singRIGHT-alt", -1, -24);
    addOffset("singLEFT-alt", -30, 15);
    addOffset("singDOWN-alt", -30, -27);
    playAnim('idle');
}