package states;

import gameplay.StrumLine;

class TestState extends MusicBeatState {
    override function create() {
        super.create();
        var strum = new StrumLine();
        add(strum);
        strum.screenCenter();
        trace(strum.members);
    }
}