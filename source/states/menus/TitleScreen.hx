package states.menus;

import flixel.addons.transition.FlxTransitionableState;
import cpp.Struct;
import flixel.util.FlxTimer;
import engine.objects.Sprite;

class TitleScreen extends MusicBeatState {
    public function new() {
        FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;
        super();
    }
    var gf:Sprite;
    var logo:Sprite;
    var enterText:Sprite;
    var danced:Bool = false;
    override function create() {
        super.create();
        Conductor.changeBPM(102);
        FlxG.sound.playMusic(Paths.music("freakyMenu"),0);
        FlxG.sound.music.fadeIn();
        gf = new Sprite(FlxG.width * 0.4, FlxG.height * 0.07);
        gf.frames = Paths.getSparrow("TitleScreen/gfDanceTitle");
        add(gf);
        gf.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gf.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
        logo = new Sprite(-150,-100);
        logo.frames = Paths.getSparrow("TitleScreen/logoBumpin");
        add(logo);
        logo.animation.addByPrefix("bump","logo bumpin",24,false);
        enterText = new Sprite(100, FlxG.height * 0.8);
        enterText.frames = Paths.getSparrow("TitleScreen/titleEnter");
        enterText.animation.addByPrefix("idle","Press Enter to Begin",24,true);
        enterText.animation.addByPrefix("pressed","ENTER PRESSED",24,true);
        add(enterText);
        enterText.play("idle",true);
    }
    override function update(elapsed:Float) {
        super.update(elapsed);
        if(FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;
        if(FlxG.keys.anyJustPressed(Controls.ui_ENTER)){
            FlxG.camera.flash();
            FlxG.sound.play(Paths.sound("confirmMenu"));
            enterText.play("pressed",true);
            new FlxTimer().start(1.2,function (tmr:FlxTimer) {
               FlxG.switchState(new MainMenu());
            });
        }
    }
    override function beatHit() {
        super.beatHit();
        if(danced)
            gf.play("danceLeft",false);
        else 
            gf.play("danceRight",false);
        danced = !danced;
        logo.play("bump",true);
    }
}