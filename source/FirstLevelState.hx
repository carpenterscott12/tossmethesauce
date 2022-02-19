package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class FirstLevelState extends FlxState
{
	var _map:FlxTilemap;
	var _background:FlxTilemap;
	var _playerCharacter:PlayerCharacter;
	var _powerup:FlxSprite;
	var _ball:Ball;
	var _throwVelocity_X:Float;
	var _throwVelocity_Y:Float;
	var _levelName:String;

	var _info:String = "LEFT & RIGHT to move, UP to jump. T to throw ball. R to reset level state. Catch the ball to win!";
	var _txtInfo:FlxText;

	public function new(throwVelocity_X:Float, throwVelocity_Y:Float, levelName:String)
	{
		super();
		_throwVelocity_X = throwVelocity_X;
		_throwVelocity_Y = throwVelocity_Y;
		_levelName = levelName;
	}

	override public function create()
	{
		// bgColor = 0xff661166;

		_background = new FlxTilemap();
		_background.loadMapFromCSV("assets/levels/" + _levelName + "/LevelBackground.csv", "assets/backgroundCafeteria.png", 32, 32);
		add(_background);

		_map = new FlxTilemap();
		_map.loadMapFromCSV("assets/levels/" + _levelName + "/LevelPlatforms.csv", "assets/TilesLevel1.png", 16, 16);
		add(_map);

		_playerCharacter = new PlayerCharacter(192, 464);
		add(_playerCharacter);

		_ball = new Ball(20, 100, _throwVelocity_X, _throwVelocity_Y);
		add(_ball);

		// _powerup = new FlxSprite(48, 208, "assets/powerup.png");
		// add(_powerup);

		_txtInfo = new FlxText(16, 16, -1, _info);
		_txtInfo.borderColor = 0xfffe8001;
		_txtInfo.borderSize = 10;
		_txtInfo.borderStyle = FlxTextBorderStyle.OUTLINE;
		add(_txtInfo);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		FlxG.collide(_map, _playerCharacter);
		// FlxG.overlap(_playerCharacter, _powerup, getPowerup);
		FlxG.overlap(_ball, _playerCharacter, roundWin);

		FlxG.collide(_map, _ball);

		if (FlxG.keys.justReleased.R)
		{
			FlxG.camera.flash(FlxColor.BLACK, .1, resetLevelStateWithParameters);
		}
	}

	function resetLevelStateWithParameters()
	{
		// Do not use FlxG.resetState here because it does not pass any parameters to the class.
		// FlxG.resetState uses switchState underneath, so it's equivalent to what we're doing here, but without useful parameters
		FlxG.switchState(new FirstLevelState(_throwVelocity_X, _throwVelocity_Y, _levelName));
	}

	// function getPowerup(playerCharacter:PlayerCharacter, particle:FlxSprite):Void
	// {
	// 	playerCharacter.fsm.transitions.replace(PlayerCharacter.Jump, PlayerCharacter.SuperJump);
	// 	playerCharacter.fsm.transitions.add(PlayerCharacter.Jump, PlayerCharacter.Idle, PlayerCharacter.Conditions.grounded);
	// 	particle.kill();
	// }

	function roundWin(ball:Ball, playerCharacter:FlxSprite):Void
	{
		_txtInfo.text = "You won!";

		var _btnReturnToMenu:FlxButton;

		ball.kill();
		_btnReturnToMenu = new FlxButton(0, 0, "Return to menu", returnToMenu);
		_btnReturnToMenu.screenCenter();
		add(_btnReturnToMenu);
		return;
	}

	function returnToMenu():Void
	{
		FlxG.switchState(new MenuState());
	}
}
