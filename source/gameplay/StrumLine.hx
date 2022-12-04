package gameplay;
// fyi this is for testing shit if you want can test shit here too :D
import flixel.group.FlxSpriteGroup;
import scripting.Hscript;
import flixel.FlxSprite;
class StrumLine extends FlxSpriteGroup {
    public function new(skinName:String = "default",hitpos = 50,keynumber:Int = 4) {
        super();
        var dirs = ["left","down","up","right"];
        for(i in 0...keynumber){
            add(new FlxSprite());
            members[i].frames = Paths.getSparrow('uiskins/$skinName/skin');
            members[i].animation.addByPrefix("static",'arrow ${dirs[i]}',24,false);
            members[i].animation.addByPrefix("pressed",'${dirs[i]} press',24,false);
            members[i].animation.addByPrefix("confirm",'${dirs[i]} confirm',24,false);
            members[i].scale.set(0.7, 0.7);
            members[i].updateHitbox();
            members[i].scrollFactor.set();
            members[i].antialiasing = true;
            members[i].y = hitpos;
            members[i].x += 110 *i;
            members[i].animation.play("static");
        }
        trace(members);


    }
}