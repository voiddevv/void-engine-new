package gameplay;

import flixel.util.FlxColor;
import haxe.io.Path;
import flixel.FlxSubState;
import sys.thread.Thread;
import flixel.FlxObject;
import scripting.Hscript;
import flixel.text.FlxText;
import openfl.events.KeyboardEvent;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxRect;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import Song.SwagSong;
import sys.FileSystem;
import flixel.math.FlxPoint;

using StringTools;

class GamePlay extends MusicBeatState
{
	public static var instance:GamePlay;
	public static var SONG:SwagSong;
	public static var storysongs:Array<String> = [];
	public static var stroySongIndex:Int = 0;
	public static var storyMode:Bool = false;
	public static var paused:Bool = false;
	public static var canPause:Bool = true;
	public static var chartDiff:String = "normal";

	public var UI:UI;
	public var notes:FlxTypedSpriteGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var camfollow:FlxObject = new FlxObject(0, 0, 1, 0);
	public var curzoom:Float;
	public var dadGroup = new FlxTypedSpriteGroup<Character>();
	public var dad:Character;
	public var bfGroup = new FlxTypedSpriteGroup<Boyfriend>();
	public var bf:Boyfriend;
	public var gfGroup = new FlxTypedSpriteGroup<Character>();
	public var gf:Character;
	public var stage:Stage;

	// cameras var
	var camGame:FlxCamera = FlxG.camera;
	var camHUD:FlxCamera;
	var camOther:FlxCamera;

	public var gennedsong:Bool = false;

	var modChart = new Hscript();

	public var camPos:FlxPoint;

	public var combo:Int = 0;
	public var health = 1.0;
	public var minHealth = 0.0;
	public var maxHealth = 2.0;
	public var misses:Int = 0;
	public var songscore:Int = 0;

	// accuracy shit
	public var totalNotes:Int = 0;
	public var totalHit:Float = 0.0;
	public var accuracy(get, null):Float = 0.0;
	public var rank:String = 'N/A';
	public var rankArray:Array<Array<Dynamic>> = [
		[0.0, 'L'],
		[0.5, 'F'],
		[0.6, 'D'],
		[0.7, 'C'],
		[0.8, 'B'],
		[0.9, 'A'],
		[0.95, 'S'],
		[1.0, 'SS']
	];

	function get_accuracy():Float
	{
		if (totalNotes == 0 || totalHit == 0)
			return 0.0;
		return totalHit / (totalNotes + misses);
	}

	public var voices = new FlxSound().loadEmbedded(Paths.voices(SONG.song));

	public function new()
	{
		super();
		instance = this;
		for (scripts in FileSystem.readDirectory('assets/data/${SONG.song.toLowerCase()}/'))
		{
			if (scripts.endsWith('.hx'))
				modChart.loadScript('data/${SONG.song.toLowerCase()}/${scripts.split(".hx")[0]}');
		}
	}

	override function create()
	{
		super.create();
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, releaseInput);
		FlxG.sound.playMusic(Paths.inst(SONG.song),0);
		// camera set up
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor = 0;
		camOther.bgColor = 0;
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther,false);
		FlxG.camera.follow(camfollow, LOCKON, 0.04);
		// stage shit
		stage = new Stage(SONG.stage);
		curzoom = stage.camZoom;
		// character shit
		bf = new Boyfriend(770, 450, SONG.player1);
		dad = new Character(100, 100, SONG.player2);
		gf = new Character(400, 130, "gf");
		// ui
		UI = new UI();
		modChart.call("create");
		// adding shit
		dadGroup.add(dad);
		bfGroup.add(bf);
		gfGroup.add(gf);
		add(stage);
		add(gfGroup);
		add(bfGroup);
		add(dadGroup);
		add(UI);
		// camera set up 2
		camPos = new FlxPoint(gf.getMidpoint().x, gf.getMidpoint().y);
		camfollow.setPosition(camPos.x, camPos.y);
		// yes leather i know this is base game
		notes = new FlxTypedSpriteGroup<Note>();
		notes.cameras = [camHUD];
		UI.cameras = [camHUD];
		add(notes);
		if (storyMode)
		{
			SONG.song = storysongs[stroySongIndex];
		}
		ChartParser.parse(chartDiff);
		camHUD.pixelPerfectRender = true;
		modChart.call("createPost");
		startCountdown();
	}

	function startMusic()
	{
		modChart.call("onStartMusic");
		FlxG.sound.playMusic(Paths.inst(SONG.song), 1, false);
		FlxG.sound.list.add(voices);
		voices.play();
	}

	function startCountdown():Void
	{
		// inCutscene = false;
		// talking = false;
		// startedCountdown = true;
		Conductor.songPosition = -Conductor.crochet * 5;
		modChart.call("onCountDown");

		var swagCounter:Int = 0;

		var startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			bf.playAnim('idle');

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready.png', "set.png", "go.png"]);
			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play('assets/sounds/intro3' + altSuffix + TitleState.soundExt, 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[0]);
					ready.scrollFactor.set();
					ready.updateHitbox();

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/intro2' + altSuffix + TitleState.soundExt, 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[1]);
					set.scrollFactor.set();

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/intro1' + altSuffix + TitleState.soundExt, 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[2]);
					go.scrollFactor.set();

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/introGo' + altSuffix + TitleState.soundExt, 0.6);
				case 4:
					startMusic();
					gennedsong = true;
			}

			swagCounter += 1;
		}, 5);
	}

	// TODO REWIRTE THE DOWN HERE
	private function popUpScore(strumtime:Float):Void
	{
		modChart.call("onPopUpScore");
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		voices.volume = 1;
		var msText:FlxText = new FlxText();
		msText.setFormat(Paths.font("vcr.ttf"), 32, 0x00fff2, CENTER, OUTLINE, 0x000000);
		msText.screenCenter();
		msText.setBorderStyle(OUTLINE, 0x000000, 3.5, 3);
		msText.scrollFactor.set();
		msText.text = '${FlxMath.roundDecimal(noteDiff, 2)} ms';
		add(msText);

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;
		totalNotes++;
		var ballin:Float = 1;
		var daRating:String = "sick";

		if (noteDiff >= 135)
		{
			daRating = 'shit';
			score = 50;
			ballin = 0.0;
			health -= 0.2;
		}
		else if (noteDiff >= 90)
		{
			daRating = 'bad';
			score = 100;

			ballin = 0.4;
		}
		else if (noteDiff >= 45)
		{
			daRating = 'good';
			score = 200;
			ballin = 0.7;
			health += 0.024;
		}
		else
		{
			health += 0.05;
		}
		totalHit += ballin;

		songscore += score;

		for (i in rankArray)
		{
			if (accuracy >= i[0])
				rank = i[1];
		}
		rating.loadGraphic(Paths.image(daRating));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image('combo'));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);
		add(msText);
		rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.antialiasing = true;
		comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
		comboSpr.antialiasing = true;
		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image('num' + Std.int(i)));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;
			numScore.antialiasing = true;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});
		FlxTween.tween(msText, {alpha: 0}, 0.2);

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();
				rating.destroy();
				msText.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
	}

	override function openSubState(SubState:FlxSubState)
	{
		super.openSubState(SubState);
		FlxG.state.persistentUpdate = false;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.camera.zoom = CoolUtil.lerp(FlxG.camera.zoom, curzoom, 0.05);
		camHUD.zoom = CoolUtil.lerp(camHUD.zoom, 1, 0.05);

		modChart.call("update", [elapsed]);
		if (health > maxHealth)
			health = 2;
		Conductor.songPosition += elapsed * 1000;
		if (gennedsong)
		{
			FlxG.sound.music.onComplete = endSong;
			if (unspawnNotes[0] != null)
			{
				if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
				{
					var dunceNote:Note = unspawnNotes[0];
					notes.add(dunceNote);

					var index:Int = unspawnNotes.indexOf(dunceNote);
					unspawnNotes.splice(index, 1);
				}
			}
			if (gennedsong)
			{
				notes.forEach(function(daNote:Note)
				{
					daNote.cameras = [camHUD];
					if (daNote.mustPress)
					{
						daNote.x = UI.playerStrum.members[daNote.noteData].x;
						if (daNote.isSustainNote)
							daNote.x += 38;
					}
					else
					{
						daNote.x = UI.dadStrum.members[daNote.noteData].x;
						if (daNote.isSustainNote)
							daNote.x += 38;
					}
					if (daNote.y > FlxG.height)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					daNote.y = (UI.dadStrum.members[daNote.noteData].y
						- (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

					// i am so fucking sorry for this if condition
					if (daNote.isSustainNote
						&& daNote.y + daNote.offset.y <= UI.dadStrum.y + 25 + Note.swagWidth / 2
						&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
					{
						var swagRect = new FlxRect(0, UI.dadStrum.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);

						swagRect.y /= daNote.scale.y;
						swagRect.height -= swagRect.y;
						swagRect.x = daNote.x;

						daNote.clipRect = swagRect;
					}
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						// if (SONG.song != 'Tutorial')
						// 	camZooming = true;
						dadNoteHit(daNote);
					}

					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

					if (daNote.y < -daNote.height)
					{
						if (daNote.tooLate || !daNote.wasGoodHit)
							noteMiss(daNote.noteData);

						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
				if (gennedsong)
					keyShit();
			}
		}
		if (gennedsong && FlxG.keys.justPressed.ENTER)
		{
			openSubState(new PauseSubState(0, 0));
			for (i in FlxG.sound.list)
				i.pause();
			FlxG.sound.music.pause();
			paused = true;
		}
	}

	function noteMiss(direction:Int = 1):Void
	{
		misses++;
		var dirs = ["LEFT", "DOWN", "UP", "RIGHT"];
		health -= 0.1;
		if (combo > 5 && gf.animOffsets.exists('sad'))
		{
			gf.playAnim('sad');
		}
		combo = 0;
		for (i in rankArray)
		{
			if (accuracy >= i[0])
				rank = i[1];
		}

		songscore -= 10;
		for (i in bfGroup.members)
		{
			i.stunned = true;
			i.playAnim('sing${dirs[direction]}miss', true);
		}
		modChart.call("onMiss");
	}

	function dadNoteHit(note:Note)
	{
		var altAnim:String = "";

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].altAnim)
				altAnim = '-alt';
		}
		modChart.call("onDadHit");
		dad.holdTimer = 0;
		var dirs = ["LEFT", "DOWN", "UP", "RIGHT"];
		for (i in dadGroup.members)
			i.playAnim('sing${dirs[note.noteData]}', true);

		UI.dadStrum.members[note.noteData].animation.play('confirm', true);
		UI.dadStrum.members[note.noteData].centerOffsets();
		UI.dadStrum.members[note.noteData].offset.set(47, 50);

		note.wasGoodHit = true;
		voices.volume = 1;

		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
		UI.dadStrum.members[note.noteData].animation.finishCallback = function(name:String)
		{
			if (name == "confirm")
				UI.dadStrum.members[note.noteData].animation.play("static");
			UI.dadStrum.members[note.noteData].updateHitbox();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		modChart.call("onPlayerHit");
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime);
				combo += 1;
			}
			var dirs = ["LEFT", "DOWN", "UP", "RIGHT"];
			for (i in bfGroup.members)
				i.playAnim('sing${dirs[note.noteData]}', true);

			UI.playerStrum.members[note.noteData].animation.play('confirm', true);
			UI.playerStrum.members[note.noteData].centerOffsets();
			// if(pixel)
			UI.playerStrum.members[note.noteData].offset.set(47, 50);

			note.wasGoodHit = true;
			voices.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	public var closestNotes:Array<Note> = [];

	var keys = [false, false, false, false];

	public function handleInput(evt:KeyboardEvent):Void
	{
		if (paused)
			return;
		@:privateAccess
		var key = FlxKey.toStringMap.get(evt.keyCode);

		var binds:Array<String> = ["d", "f", "j", "k"];

		var data = -1;
		if (gennedsong)
		{
			for (i in 0...binds.length) // binds
			{
				if (binds[i].toLowerCase() == key.toLowerCase())
					data = i;
			}
			if (data == -1)
			{
				return;
			}
			if (keys[data])
			{
				return;
			}

			keys[data] = true;

			closestNotes = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.wasGoodHit)
					closestNotes.push(daNote);
			}); // Collect notes that can be hit

			closestNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			var dataNotes = [];
			for (i in closestNotes)
				if (i.noteData == data && !i.isSustainNote)
					dataNotes.push(i);

			// trace("notes able to hit for " + key.toString() + " " + dataNotes.length);
			UI.playerStrum.members[data].animation.play('pressed');
			UI.playerStrum.members[data].centerOffsets();

			if (dataNotes.length != 0)
			{
				var coolNote = null;

				for (i in dataNotes)
				{
					coolNote = i;
					break;
				}

				if (dataNotes.length > 1) // stacked notes or really close ones
				{
					for (i in 0...dataNotes.length)
					{
						if (i == 0) // skip the first note
							continue;

						var note = dataNotes[i];

						if (!note.isSustainNote && ((note.strumTime - coolNote.strumTime) < 2) && note.noteData == data)
						{
							trace('found a stacked/really close note ' + (note.strumTime - coolNote.strumTime));
							// just fuckin remove it since it's a stacked note and shouldn't be there
							note.kill();
							notes.remove(note, true);
							note.destroy();
						}
					}
				}

				bf.holdTimer = 0;
				goodNoteHit(coolNote);
				var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
			}
		}
	}

	public function releaseInput(evt:KeyboardEvent):Void // handles releases
	{
		@:privateAccess
		var key = FlxKey.toStringMap.get(evt.keyCode);

		var binds:Array<String> = ["d", "f", "j", "k"];

		var data = -1;

		for (i in 0...binds.length) // binds
		{
			if (binds[i].toLowerCase() == key.toLowerCase())
				data = i;
		}

		if (data == -1)
			return;

		keys[data] = false;
		UI.playerStrum.members[data].animation.play("static");
		UI.playerStrum.members[data].centerOffsets();
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	private function keyShit():Void // I've invested in emma stocks
	{
		if (paused)
			return;
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [
			FlxG.keys.pressed.D,
			FlxG.keys.pressed.F,
			FlxG.keys.pressed.J,
			FlxG.keys.pressed.K
		];
		var pressArray:Array<Bool> = [
			FlxG.keys.justPressed.D,
			FlxG.keys.justPressed.F,
			FlxG.keys.justPressed.J,
			FlxG.keys.justPressed.K
		];
		var releaseArray:Array<Bool> = [
			FlxG.keys.justReleased.D,
			FlxG.keys.justReleased.F,
			FlxG.keys.justReleased.J,
			FlxG.keys.justReleased.K
		];
		var keynameArray:Array<String> = ['left', 'down', 'up', 'right'];

		// Prevent player input if botplay is on

		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && gennedsong)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
				{
					goodNoteHit(daNote);
				}
			});
		}

		if ((!FlxG.keys.justPressed.ANY))
		{
			// PRESSES, check for note hits
			if (pressArray.contains(true) && gennedsong)
			{
				bf.holdTimer = 0;

				var possibleNotes:Array<Note> = []; // notes that can be hit
				var directionList:Array<Int> = []; // directions that can be hit
				var dumbNotes:Array<Note> = []; // notes to kill later
				var directionsAccounted:Array<Bool> = [false, false, false, false]; // we don't want to do judgments for more than one presses

				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.wasGoodHit && !directionsAccounted[daNote.noteData])
					{
						if (directionList.contains(daNote.noteData))
						{
							directionsAccounted[daNote.noteData] = true;
							for (coolNote in possibleNotes)
							{
								if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
								{ // if it's the same note twice at < 10ms distance, just delete it
									// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
									dumbNotes.push(daNote);
									break;
								}
								else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
								{ // if daNote is earlier than existing note (coolNote), replace
									possibleNotes.remove(coolNote);
									possibleNotes.push(daNote);
									break;
								}
							}
						}
						else
						{
							directionsAccounted[daNote.noteData] = true;
							possibleNotes.push(daNote);
							directionList.push(daNote.noteData);
						}
					}
				});

				for (note in dumbNotes)
				{
					FlxG.log.add("killing dumb ass note at " + note.strumTime);
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}

				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

				var hit = [false, false, false, false];

				// if (perfectMode)
				// 	goodNoteHit(possibleNotes[0]);
				if (possibleNotes.length > 0)
				{
					if (!FlxG.save.data.ghost)
					{
						for (shit in 0...pressArray.length)
						{ // if a direction is hit that shouldn't be
							if (pressArray[shit] && !directionList.contains(shit))
								noteMiss(shit);
						}
					}
					for (coolNote in possibleNotes)
					{
						if (pressArray[coolNote.noteData] && !hit[coolNote.noteData])
						{
							hit[coolNote.noteData] = true;
							var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
							goodNoteHit(coolNote);
						}
					}
				};
				else if (!FlxG.save.data.ghost)
				{
					for (shit in 0...pressArray.length)
						if (pressArray[shit])
							noteMiss(shit);
				}
			}
		}
		if (bf.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true)))
		{
			if (bf.animation.curAnim.name.startsWith('sing') && !bf.animation.curAnim.name.endsWith('miss'))
				bf.dance();
		}
	}

	public function syncAudio()
	{
		trace("synced audio");
		Conductor.songPosition = voices.time = FlxG.sound.music.time;
	}

	override function stepHit()
	{
		super.stepHit();
		camfollow.setPosition(camPos.x, camPos.y);
		modChart.interp.variables.set("curStep", curStep);
		modChart.call("stepHit", [curStep]);
		// section shit
		if (SONG.notes[Std.int(curStep / 16)] != null && SONG.notes[Std.int(curStep / 16)].mustHitSection)
			camPos.set(bf.getMidpoint().x + bf.camoffset[0], bf.getMidpoint().y + bf.camoffset[1]);
		else
			camPos.set(dad.getMidpoint().x + dad.camoffset[0], dad.getMidpoint().y + dad.camoffset[1]);
	}

	override function beatHit()
	{
		super.beatHit();
		UI.iconBump();
		if (!bf.animation.name.startsWith("sing"))
			bf.dance();
		if (!dad.animation.name.startsWith("sing"))
			dad.dance();
		if (!gf.animation.name.startsWith("sing"))
			gf.dance();
		modChart.interp.variables.set("curBeat", curBeat);
		modChart.call("beatHit", [curBeat]);
		if (Conductor.songPosition - FlxG.sound.music.time > 20 || Conductor.songPosition - FlxG.sound.music.time < -20)
			syncAudio();
		if (curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
	}

	public function endSong()
	{
		modChart.call("onEndSong");
		if (storyMode)
		{
			stroySongIndex++;
			FlxG.resetState();
		}
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleInput);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
		MemUtil.clearAll();
		paused = false;
		FlxG.switchState(new MainMenuState());
	}
}
