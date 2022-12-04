function new(){
    frames = Paths.getCharacter("SPARROW",curCharacter);
    frames = Paths.getCharacterSparrow("monster-christmas");
    animation.addByPrefix('idle', 'monster idle', 24, false);
    animation.addByPrefix('singUP', 'monster up note', 24, false);
    animation.addByPrefix('singDOWN', 'monster down', 24, false);
    animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
    animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

    addOffset('idle');
    addOffset("singUP", -20, 50);
    addOffset("singRIGHT", -51);
    addOffset("singLEFT", -30);
    addOffset("singDOWN", -40, -94);
    playAnim('idle');
}