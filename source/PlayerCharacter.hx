package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;
import flixel.system.FlxSound;

class PlayerCharacter extends FlxSprite
{
	public static inline var GRAVITY:Float = 600;

	public var fsm:FlxFSM<PlayerCharacter>;

	public var jumpSound:FlxSound;

	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);

		jumpSound = FlxG.sound.load("assets/sounds/Jump.wav");

		loadGraphic("assets/playerCharacter.png", true, 16, 16);
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);
		facing = RIGHT;

		animation.add("standing", [0, 1], 3);
		animation.add("walking", [0, 1], 12);
		animation.add("jumping", [2]);
		animation.add("pound", [3]);
		animation.add("landing", [4, 0, 1, 0], 8, false);

		acceleration.y = GRAVITY;
		maxVelocity.set(500, GRAVITY);

		fsm = new FlxFSM<PlayerCharacter>(this);
		fsm.transitions.add(Idle, Jump, Conditions.jump)
			.add(Jump, Jump, Conditions.jump) // For wall jump (or double jump if that is allowed in jump logic)
			.add(Jump, Idle, Conditions.grounded)
			.add(Jump, GroundPound, Conditions.groundSlam)
			.add(GroundPound, GroundPoundFinish, Conditions.grounded)
			.add(GroundPoundFinish, Idle, Conditions.animationFinished)
			.start(Idle);
	}

	override public function update(elapsed:Float):Void
	{
		fsm.update(elapsed);
		super.update(elapsed);
	}

	override public function destroy():Void
	{
		fsm.destroy();
		fsm = null;
		super.destroy();
	}
}

class Conditions
{
	public static function jump(Owner:PlayerCharacter):Bool
	{
		// Owner.isTouching(DOWN) means the Owner is touching a surface that is below the Owner
		return (FlxG.keys.justPressed.UP && (Owner.isTouching(DOWN) || Owner.isTouching(LEFT) || Owner.isTouching(RIGHT)));
	}

	public static function grounded(Owner:PlayerCharacter):Bool
	{
		return Owner.isTouching(DOWN);
	}

	public static function groundSlam(Owner:PlayerCharacter):Bool
	{
		return FlxG.keys.justPressed.DOWN && !Owner.isTouching(DOWN);
	}

	public static function animationFinished(Owner:PlayerCharacter):Bool
	{
		return Owner.animation.finished;
	}
}

class Idle extends FlxFSMState<PlayerCharacter>
{
	override public function enter(owner:PlayerCharacter, fsm:FlxFSM<PlayerCharacter>):Void
	{
		owner.animation.play("standing");
	}

	override public function update(elapsed:Float, owner:PlayerCharacter, fsm:FlxFSM<PlayerCharacter>):Void
	{
		owner.acceleration.x = 0;
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
		{
			owner.facing = FlxG.keys.pressed.LEFT ? LEFT : RIGHT;
			owner.animation.play("walking");
			owner.acceleration.x = FlxG.keys.pressed.LEFT ? -200 : 200;
		}
		else
		{
			owner.animation.play("standing");
			// This is the rate at which the owner slows down after releasing a control direction
			owner.velocity.x *= 0.9;
		}
	}
}

class Jump extends FlxFSMState<PlayerCharacter>
{
	override public function enter(owner:PlayerCharacter, fsm:FlxFSM<PlayerCharacter>):Void
	{
		owner.jumpSound.play();
		owner.animation.play("jumping");
		owner.velocity.y = -300;
	}

	override public function update(elapsed:Float, owner:PlayerCharacter, fsm:FlxFSM<PlayerCharacter>):Void
	{
		owner.acceleration.x = 0;
		// This part allows the character to move left and right while in the air
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
		{
			owner.acceleration.x = FlxG.keys.pressed.LEFT ? -300 : 300;
		}
	}
}

// class SuperJump extends Jump
// {
// 	override public function enter(owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void
// 	{
// 		owner.animation.play("jumping");
// 		owner.velocity.y = -300;
// 	}
// }

class GroundPound extends FlxFSMState<PlayerCharacter>
{
	var _ticks:Float;

	override public function enter(owner:PlayerCharacter, fsm:FlxFSM<PlayerCharacter>):Void
	{
		owner.animation.play("pound");
		owner.velocity.x = 0;
		owner.acceleration.x = 0;
		_ticks = 0;
	}

	override public function update(elapsed:Float, owner:PlayerCharacter, fsm:FlxFSM<PlayerCharacter>):Void
	{
		_ticks++;
		if (_ticks < 15)
		{
			owner.velocity.y = 0;
		}
		else
		{
			owner.velocity.y = PlayerCharacter.GRAVITY;
		}
	}
}

class GroundPoundFinish extends FlxFSMState<PlayerCharacter>
{
	override public function enter(owner:PlayerCharacter, fsm:FlxFSM<PlayerCharacter>):Void
	{
		owner.animation.play("landing");
		FlxG.camera.shake(0.025, 0.25);
		owner.velocity.x = 0;
		owner.acceleration.x = 0;
	}
}
