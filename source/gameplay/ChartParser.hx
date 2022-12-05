package gameplay;

import openfl.Assets;
import Song.SwagSong;
import Section.SwagSection;
import haxe.Json;
import flixel.util.FlxSort;
class ChartParser {
    public static function parse(data:String,diff:String = "") {
        var songData:SwagSong = Json.parse(Assets.getText(Paths.json('data/${data.toLowerCase()}/${data.toLowerCase()}-$diff'))).song;
		Conductor.changeBPM(songData.bpm);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (GamePlay.instance.unspawnNotes.length > 0)
					oldNote = GamePlay.instance.unspawnNotes[Std.int(GamePlay.instance.unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				GamePlay.instance.unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = GamePlay.instance.unspawnNotes[Std.int(GamePlay.instance.unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
					sustainNote.scrollFactor.set();
					GamePlay.instance.unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}
				swagNote.mustPress = gottaHitNote;
				if (swagNote.mustPress)
					swagNote.x += FlxG.width / 2; // general offset
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		GamePlay.instance.unspawnNotes.sort(noteSort);
		GamePlay.instance.gennedsong = true;
    }
    public static function noteSort(Obj1:Note, Obj2:Note):Int
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
}