function new(){
    frames = Paths.getCharacter("SPARROW",curCharacter);
    icon = "mom";
    animation.addByPrefix('idle', "Mom Idle", 24, false);
    animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
    animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
    animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
    // ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
    // CUZ DAVE IS DUMB!
    animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);
    addOffset('idle');
    addOffset("singUP", 14, 71);
    addOffset("singRIGHT", 10, -60);
    addOffset("singLEFT", 250, -23);
    addOffset("singDOWN", 20, -160);

    playAnim('idle');
}