function new(){
    frames = Paths.getCharacter("PACKER",curCharacter);
    animation.addByPrefix('idle', "idle spirit_", 24, false);
    animation.addByPrefix('singUP', "up_", 24, false);
    animation.addByPrefix('singRIGHT', "right_", 24, false);
    animation.addByPrefix('singLEFT', "left_", 24, false);
    animation.addByPrefix('singDOWN', "spirit down_", 24, false);

    addOffset('idle', -220, -280);
    addOffset('singUP', -220, -240);
    addOffset("singRIGHT", -220, -280);
    addOffset("singLEFT", -200, -280);
    addOffset("singDOWN", 170, 110);

    setGraphicSize(Std.int(width * 6));
    updateHitbox();

    playAnim('idle');

    antialiasing = false;
}