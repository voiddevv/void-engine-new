package states.menus.editers;

import gameplay.Stage;

class CharacterEditer extends MusicBeatState {
    var character:Character;
    override function create() {
        super.create();
        character = new Character(100,100,"dad");
        var stage:Stage = new Stage("stage");
        add(stage);
        FlxG.camera.zoom = 0.9;
        add(character);
    }
    override function update(elasped:Float) {
        super.update(elasped);
        
    }
}