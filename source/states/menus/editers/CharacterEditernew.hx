// package states.menus.editers;

// import haxe.ui.components.DropDown;
// import haxe.ui.components.DropDown.DropDownHandler;
// import haxe.ui.containers.Box;
// import haxe.ui.layouts.Layout;
// import haxe.ui.Toolkit;
// import haxe.ui.containers.ButtonBar;
// import haxe.ui.components.Button;
// import haxe.ui.HaxeUIApp;
// import haxe.Json;
// import openfl.net.FileReference;
// import flixel.group.FlxSpriteGroup;
// import flixel.addons.ui.FlxUIInputText;
// import Character.CharacterJson;
// import flixel.addons.ui.FlxUITabMenu;
// import flixel.addons.ui.FlxUIDropDownMenu;
// import flixel.text.FlxText;
// import flixel.FlxCamera;
// import gameplay.Stage;
// import flixel.ui.FlxButton;

// class CharacterEditornew extends MusicBeatState
// {
// 	var file:FileReference;
// 	var json:CharacterJson;
// 	var uiCAM = new FlxCamera(0, 0, 1280, 720, 1);
// 	var character:Character;
// 	var animList:Array<String> = [];
// 	var curAnim:String = "idle";
// 	var animsText:FlxText;
// 	var animDropDown:FlxUIDropDownMenu;
// 	var uiBox:haxe.ui.containers.Box;
// 	var saveBut:Button;
// 	var offsetsTextBox:FlxUIInputText;
// 	var saveButNew:Button;
// 	var characterTab = new FlxSpriteGroup();
// 	var AnimTab = new FlxSpriteGroup();
// 	var tabs = [
// 		{name: "Character", label: 'Character'},
// 		{name: "Animation", label: 'Animation'},
// 	];

// 	override function create()
// 	{
// 		Toolkit.init();
// 		FlxG.mouse.useSystemCursor = true;
// 		uiCAM.bgColor = 0;
// 		saveBut = new Button();
// 		saveBut.text = "Save Character";
// 		saveBut.fontSize = 16;
// 		saveBut.onClick = function(click)
// 		{
// 			FlxG.log.notice("saveing data");
// 			file = new FileReference();
// 			file.save(Json.stringify(json, "\t"), "character.json");
// 		}
// 		FlxG.cameras.add(uiCAM, false);
// 		offsetsTextBox = new FlxUIInputText(0, 75, 100, "", 12, 0xFF000000, 0xFFFFFFFF);
// 		offsetsTextBox.screenCenter(X);
// 		offsetsTextBox.x += 530;
// 		saveBut.screenCenter(X);
// 		saveBut.x += 530;
// 		super.create();
// 		uiBox = new Box();
// 		uiBox.setSize(500,720);
// 		uiBox.backgroundColor = 0xf7929292;
// 		uiBox.backgroundColorEnd = 0xFF00FF22;
// 		uiBox.x = 720;
// 		character = new Character(100, 100, "dad");
		
// 		if (character.json != null)
// 		{
// 			json = character.json;
// 			FlxG.log.notice("json Found For Character " + character.curCharacter);
// 		}
// 		else
// 		{
// 			FlxG.log.error("json not Found For Character " + character.curCharacter);
// 		}
// 		animList = character.animation.getNameList();
// 		curAnim = animList[0];
// 		var animDropDown = new DropDown();
// 		animDropDown.setSize(50,15);
// 		for(i in animList)
// 			animDropDown.dataSource.add(i);

// 		// animDropDown = new FlxUIDropDownMenu(1115, 75 / 2, FlxUIDropDownMenu.makeStrIdLabelArray(animList, false), function(anim:String)
// 		// {
// 		// 	character.playAnim(anim, true);
// 		// 	curAnim = anim;
// 		// });
// 		animDropDown.screenCenter(X);
// 		var stage:Stage = new Stage("stage");
// 		add(stage);
// 		add(character);
// 		add(uiBox);
// 		characterTab.add(saveBut);
// 		AnimTab.add(offsetsTextBox);
// 		AnimTab.add(animDropDown);
// 		add(characterTab);
// 		add(AnimTab);
//         add(saveButNew);
// 		AnimTab.cameras = [uiCAM];
// 		characterTab.cameras = [uiCAM];
// 		uiBox.cameras = [uiCAM];
// 		offsetsTextBox.cameras = [uiCAM];
// 		saveBut.cameras = [uiCAM];
// 		animDropDown.cameras = [uiCAM];
// 		// uiBox.getTab("Character").toggled = true;
// 	}

// 	override function update(elasped:Float)
// 	{
// 		character.addOffset(animList[animList.indexOf(curAnim)], Std.parseFloat(offsetsTextBox.text.split(",")[0]),
// 			Std.parseFloat(offsetsTextBox.text.split(",")[1]));
// 		// json.anims[animList.indexOf(curAnim)].offsets =
// 		// if (uiBox.getTab("Character").toggled)
// 		// {
// 		// 	characterTab.visible = true;
// 		// 	AnimTab.visible = false;
// 		// }
// 		// else
// 		// {
// 		// 	characterTab.visible = false;
// 		// 	AnimTab.visible = true;
// 		// }
// 		super.update(elasped);
// 		if (FlxG.keys.justPressed.SPACE){
// 			character.playAnim(curAnim, true);
// 			FlxG.log.add(curAnim);
// 		}
// 		if (FlxG.keys.pressed.Q)
// 			FlxG.camera.zoom -= 1 * elasped;
// 		if (FlxG.keys.pressed.E)
// 			FlxG.camera.zoom += 1 * elasped;
// 	}
// }
