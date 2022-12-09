function new(){
    camZoom = 0.9;
    var bg = new FlxSprite(-600, -200);
    bg.frames = Paths.getSparrow('stages/Maze/bg');
    bg.animation.addByPrefix('Maze','Stage', 16);
    bg.antialiasing = true;
    bg.scrollFactor.set(0.9, 0.9);
    bg.animation.play('Maze');
    add(bg);
}