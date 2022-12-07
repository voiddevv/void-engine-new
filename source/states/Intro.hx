package states;
class Intro extends MusicBeatState {
    override function create() {
        super.create();
        FlxG.save.bind("Void-Engine","VoidDev");
        if(FlxG.save.data.gamePlay = null){
            FlxG.save.data.gamePlay = OptionsData.gamePlay;
            FlxG.save.flush();
            trace("save data was null");
        }

        FlxG.switchState(new TitleState());
    }
}