package;
import flixel.input.actions.FlxAction;
import flixel.graphics.frames.FlxAtlasFrames;
using StringTools;
enum AtlasType{
    SPARROW;
    PACKER;
}
class Paths {
    public static function getPath(path:String) {
        return 'assets/$path';
    }
    public static function font(file:String) {
        return getPath('fonts/$file');
    }
    public static function image(file:String) {
        return getPath('images/$file.png');
    }
    public static function json(file:String) {
        return getPath('$file.json');
    }
    public static function xml(file:String) {
        return getPath('$file.xml');
    }
    public static function sound(file:String) {
        return getPath('sounds/$file.ogg');
    }
    public static function music(file:String) {
        return getPath('music/$file.ogg');
    }
    public static function getSparrow(file:String) {
        return FlxAtlasFrames.fromSparrow(image(file),xml('images/$file'));
    }
    public static function getPacker(file:String) {
        return FlxAtlasFrames.fromSpriteSheetPacker(image(file),getPath('images/$file.txt'));
    }
    public static function getCharacter(type:String,char:String) {
        switch (type){
            case "SPARROW":
                return getSparrow('characters/$char/character');
            case "PACKER":
                return getPacker('characters/$char/character');
            
        }
        return null;
        
    }
    public static function inst(song:String) {
        return getPath('songs/${song.toLowerCase()}/Inst.ogg');
    }
    public static function voices(song:String) {
        return getPath('songs/${song.toLowerCase()}/Voices.ogg');
    }
    public static function getScript(file:String) {
        return getPath('$file.hx');
    }
}