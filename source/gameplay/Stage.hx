package gameplay;

import scripting.Hscript;
import flixel.group.FlxSpriteGroup;

class Stage extends FlxSpriteGroup {
    var script = new Hscript();
    public function new(stage:String = 'stage') {
        super();
        var camzoom = 1.05;
        script.interp.scriptObject = this;
        try{
            script.loadScript('images/stages/$stage/stage');
        }
        catch(e){
            trace(e.details());
            script.loadScript('images/stages/stage/stage');
        }
        script.call("new");
    }
    override function update(elapsed:Float) {
        super.update(elapsed);
        script.call("update",[elapsed]);
    }
}