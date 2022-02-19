package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

class FirstLevelState extends FlxState
{
    var _map:FlxTilemap;
	var _slime:Slime;
    var _powerup:FlxSprite;
	var _ball:Ball;
    
    var _info:String = "LEFT & RIGHT to move, UP to jump. Current State: {STATE}";
    var _txtInfo:FlxText;
    
	override public function create()
	{
        bgColor = 0xff661166;

        _map = new FlxTilemap();
		_map.loadMapFromArray([
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
			1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
			1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
			1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
        ], 20, 15, "assets/tiles.png", 16, 16);
        add(_map);

        _slime = new Slime(192, 128);
		add(_slime);

		_ball = new Ball(100, 100);
		add(_ball);

		_powerup = new FlxSprite(48, 208, "assets/powerup.png");
		add(_powerup);

		_txtInfo = new FlxText(16, 16, -1, _info);
		add(_txtInfo);

		super.create();
	}

	override public function update(elapsed:Float):Void
        {
            super.update(elapsed);
    
            FlxG.collide(_map, _slime);
            FlxG.overlap(_slime, _powerup, getPowerup);
			FlxG.overlap(_ball, _slime, roundWin);

			FlxG.collide(_map, _ball);
    
            // _txtInfo.text = _info.replace("{STATE}", Type.getClassName(_slime.fsm.stateClass));
    
            if (FlxG.keys.justReleased.R)
            {
                FlxG.camera.flash(FlxColor.BLACK, .1, FlxG.resetState);
            }
        }
    
        function getPowerup(slime:Slime, particle:FlxSprite):Void
        {
            slime.fsm.transitions.replace(Slime.Jump, Slime.SuperJump);
            slime.fsm.transitions.add(Slime.Jump, Slime.Idle, Slime.Conditions.grounded);
    
            particle.kill();
        }

		function roundWin(ball:Ball, slime:FlxSprite):Void
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
