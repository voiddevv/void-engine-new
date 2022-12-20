package states.menus.editers;

import states.menus.editers.submenus.AddAnim;
import flixel.math.FlxRect;
import sys.FileSystem;
import openfl.Assets;
import haxe.Json;
import openfl.net.FileReference;
import flixel.group.FlxSpriteGroup;
import flixel.addons.ui.FlxUIInputText;
import Character.CharacterJson;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.text.FlxText;
import flixel.FlxCamera;
import gameplay.Stage;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxInputText;

class CharacterEditor extends MusicBeatState
{
	var file:FileReference;

	public var json:CharacterJson;

	public static var current:CharacterEditor;

	public var uiCAM = new FlxCamera(0, 0, 1280, 720, 1);
	public var character:Character;
	public var animList:Array<String> = [];
	public var curAnim:String = "idle";

	var animsText:FlxText;
	var animDropDown:FlxUIDropDownMenu;
	var characterDropDown:FlxUIDropDownMenu;
	var uiBox:FlxUITabMenu;
	var saveBut:FlxButton;
	var offsetsTextBox:FlxUIInputText;
	var characterTab = new FlxSpriteGroup();
	var AnimTab = new FlxSpriteGroup();
	var addAnimBut:FlxButton;
	var textHitBox:FlxRect;
	var tabs = [
		{name: "Character", label: 'Character'},
		{name: "Animation", label: 'Animation'},
	];

	override function create()
	{
		current = this;
		character = new Character(100, 100, "dad");
		if (character.json != null)
		{
			json = character.json;
			FlxG.log.notice("json Found For Character " + character.curCharacter);
		}
		else
		{
			FlxG.log.error("json not Found For Character " + character.curCharacter);
		}
		var charactersList:Array<String> = [];
		FlxG.mouse.useSystemCursor = true;
		for (dir in FileSystem.readDirectory('assets/images/characters'))
		{
			if (FileSystem.isDirectory('assets/images/characters/$dir'))
				charactersList.push(dir);
		}
		addAnimBut = new FlxButton(1130, 150, "Add Anim", function()
		{
			openSubState(new AddAnim());
		});

		uiCAM.bgColor = 0;
		FlxG.cameras.add(uiCAM, false);
		offsetsTextBox = new FlxUIInputText(0, 75, 100, '', 12, 0xFF000000, 0xFFFFFFFF);
		offsetsTextBox.callback = function(text:String, cool:String)
		{
			try
			{
				var oyeahaha = text.split(",");
				var offsets = [Std.parseFloat(oyeahaha[0]), Std.parseFloat(oyeahaha[1])];
				if (Math.isNaN(offsets[0]) || Math.isNaN(offsets[1]))
					return;
				var i:Int = 0;
				for (anims in json.anims)
				{
					var name = anims.name;
					if (name == curAnim)
					{
						json.anims[i].offsets = offsets;
						character.addOffset(curAnim, offsets[0], offsets[1]);
					}
					i++;
				}

				trace(json.anims[animList.indexOf(curAnim)].offsets);
			}
			catch (e)
			{
				FlxG.log.error(e.details());
			}
		}

		offsetsTextBox.screenCenter(X);
		offsetsTextBox.x += 530;
		textHitBox = new FlxRect(offsetsTextBox.x, offsetsTextBox.y, offsetsTextBox.width, offsetsTextBox.height);
		saveBut = new FlxButton(50, 175, "Save Character", function()
		{
			FlxG.log.notice("saveing data");
			file = new FileReference();
			file.save(Json.stringify(json, "\t"), "character.json");
			trace(json);
		});
		saveBut.screenCenter(X);
		saveBut.x += 530;
		super.create();
		uiBox = new FlxUITabMenu(null, tabs, true);
		uiBox.x = 1078;
		characterDropDown = new FlxUIDropDownMenu(uiBox.x + 30, 100, FlxUIDropDownMenu.makeStrIdLabelArray(charactersList, false), function(character:String)
		{
			try
			{
				this.character.changeCharacter(character);
				animList = this.character.animation.getNameList();
				animDropDown.setData(FlxUIDropDownMenu.makeStrIdLabelArray(animList, false));
				json = this.character.json;
			}
			catch (e)
			{
				FlxG.log.error(e.details());
				json = {
					icon: "dad",
					singDur:  4.0,
					barColor: "0xFFFF0000",
					antialiasing: true,
					type: "SPARROW",
					danceSteps: ["idle"],
					camOffsets: [0,0],
					anims: []
				}
			}
			FlxG.log.add(character);
		});

		animList = character.animation.getNameList();
		curAnim = animList[0];

		animDropDown = new FlxUIDropDownMenu(1115, 75 / 2, FlxUIDropDownMenu.makeStrIdLabelArray(animList, false), function(anim:String)
		{
			character.playAnim(anim, true);
			curAnim = anim;
			if (character != null && character.animOffsets.exists(curAnim))
				offsetsTextBox.text = character.animOffsets.get(curAnim)[0] + "," + character.animOffsets.get(curAnim)[1];
		});
		animDropDown.screenCenter(X);
		animDropDown.x += 530;
		animDropDown.setSize(300, 150);
		var stage:Stage = new Stage("stage");
		add(stage);
		add(character);
		add(uiBox);
		characterTab.add(saveBut);
		characterTab.add(characterDropDown);
		AnimTab.add(offsetsTextBox);
		AnimTab.add(animDropDown);
		AnimTab.add(addAnimBut);
		add(characterTab);

		add(AnimTab);
		AnimTab.cameras = [uiCAM];
		characterTab.cameras = [uiCAM];
		uiBox.cameras = [uiCAM];
		offsetsTextBox.cameras = [uiCAM];
		saveBut.cameras = [uiCAM];
		animDropDown.cameras = [uiCAM];
		uiBox.getTab("Character").toggled = true;
	}

	public function addAnim(name:String, xmlName:String, fps:Int)
	{
		json.anims.push({
			name: name,
			nameInXml: xmlName,
			offsets: [0, 0],
			frameRate: fps,
			looped: false
		});
		character.animation.addByPrefix(name, xmlName, fps, false);
		character.json = json;
		animDropDown.setData(FlxUIDropDownMenu.makeStrIdLabelArray(animList));
	}

	override function update(elasped:Float)
	{
		// character.addOffset(animList[animList.indexOf(curAnim)], Std.parseFloat(offsetsTextBox.text.split(",")[0]),
		// 	Std.parseFloat(offsetsTextBox.text.split(",")[1]));
		// json.anims[animList.indexOf(curAnim)].offsets = cast((offsetsTextBox.text.split(",")));
		if (uiBox.getTab("Character").toggled)
		{
			characterTab.visible = true;
			AnimTab.visible = false;
		}
		else
		{
			characterTab.visible = false;
			AnimTab.visible = true;
		}
		super.update(elasped);
		if (FlxG.keys.justPressed.SPACE)
		{
			character.playAnim(curAnim, true);
			trace(curAnim);
		}
		if (FlxG.keys.pressed.Q)
			FlxG.camera.zoom -= 1 * elasped;
		if (FlxG.keys.pressed.E)
			FlxG.camera.zoom += 1 * elasped;
	}
}
