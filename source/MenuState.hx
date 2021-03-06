package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	var _btnLevel1:FlxButton;
	var _btnLevel2:FlxButton;
	var _btnLevel3:FlxButton;

	override public function create():Void
	{
		if (FlxG.sound.music == null) // prevents restarting the music if it's already playing
		{
			FlxG.sound.playMusic("assets/music/Peaceful Woods.wav", 1, true);
		}

		_btnLevel1 = new FlxButton(0, 0, "Level 1", clickLevel1);
		_btnLevel1.x = 100;
		_btnLevel1.y = 100;
		add(_btnLevel1);
		_btnLevel2 = new FlxButton(0, 0, "Level 2", clickLevel2);
		_btnLevel2.x = 200;
		_btnLevel2.y = 200;
		add(_btnLevel2);
		_btnLevel3 = new FlxButton(0, 0, "Level 3", clickLevel3);
		_btnLevel3.x = 300;
		_btnLevel3.y = 300;
		add(_btnLevel3);
		super.create();
	}

	function clickLevel1():Void
	{
		FlxG.switchState(new FirstLevelState(500, -200, "Level1"));
	}

	function clickLevel2():Void
	{
		FlxG.switchState(new FirstLevelState(700, -200, "Level2"));
	}

	function clickLevel3():Void
	{
		FlxG.switchState(new FirstLevelState(800, -100, "Level3"));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
