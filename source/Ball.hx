package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxTween;

class Ball extends FlxSprite
{
	public static inline var GRAVITY:Float = 600;

	public var _throwVelocity_X:Float;
	public var _throwVelocity_Y:Float;
	public var fsm:FlxFSM<Ball>;

	public function new(X:Float = 0, Y:Float = 0, throwVelocity_X:Float = 0, throwVelocity_Y:Float = 0)
	{
		super(X, Y);

		_throwVelocity_X = throwVelocity_X;
		_throwVelocity_Y = throwVelocity_Y;

		loadGraphic("assets/ball.png", true, 16, 16);
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);
		facing = RIGHT;

		animation.add("standing", [0, 1], 3);
		animation.add("walking", [0, 1], 12);
		animation.add("jumping", [2]);
		animation.add("pound", [3]);
		animation.add("landing", [4, 0, 1, 0], 8, false);

		acceleration.y = 0;
		maxVelocity.set(500, GRAVITY);
		fsm = new FlxFSM<Ball>(this);
		fsm.transitions.add(StartingBall, Throw, BallConditions.launch)
			.add(Throw, GroundedBall, BallConditions.grounded) // .add(GroundedBall, ReflectLeft, BallConditions.collideRight)
				// .add(GroundedBall, ReflectRight, BallConditions.collideLeft)
			.start(StartingBall);
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

class BallConditions
{
	public static function launch(Owner:FlxSprite):Bool
	{
		return (FlxG.keys.justPressed.T);
	}

	public static function grounded(Owner:FlxSprite):Bool
	{
		return Owner.isTouching(DOWN);
	}

	public static function collideRight(Owner:FlxSprite):Bool
	{
		return Owner.isTouching(RIGHT);
	}

	public static function collideLeft(Owner:FlxSprite):Bool
	{
		return Owner.isTouching(LEFT);
	}

	public static function animationFinished(Owner:FlxSprite):Bool
	{
		return Owner.animation.finished;
	}
}

class Throw extends FlxFSMState<Ball>
{
	override public function enter(owner:Ball, fsm:FlxFSM<Ball>):Void
	{
		owner.animation.play("jumping");
		// owner.velocity.y = -300;
		// owner.velocity.x = 1000;
		owner.velocity.x = owner._throwVelocity_X;
		owner.velocity.y = owner._throwVelocity_Y;
		owner.acceleration.y = Ball.GRAVITY;
	}

	override public function update(elapsed:Float, owner:Ball, fsm:FlxFSM<Ball>):Void
	{
		owner.animation.play("jumping");
		FlxTween.tween(owner, {x: owner.velocity.x, y: owner.velocity.y, angle: 180}, 1, {type: ONESHOT, ease: FlxEase.quintOut});
	}
}

class StartingBall extends FlxFSMState<Ball>
{
	override public function enter(owner:Ball, fsm:FlxFSM<Ball>):Void
	{
		owner.animation.play("standing");
	}

	override public function update(elapsed:Float, owner:Ball, fsm:FlxFSM<Ball>):Void
	{
		owner.animation.play("standing");
	}
}

class GroundedBall extends FlxFSMState<Ball>
{
	override public function enter(owner:Ball, fsm:FlxFSM<Ball>):Void
	{
		owner.animation.play("standing");
	}

	override public function update(elapsed:Float, owner:Ball, fsm:FlxFSM<Ball>):Void
	{
		owner.animation.play("standing");
		owner.velocity.x *= 0.99;
		FlxTween.tween(owner, {x: owner.velocity.x, y:owner.velocity.y, angle: 180}, 1, {type: ONESHOT, ease: FlxEase.quintOut});
	}
}

// // TODO: ReflectLeft and ReflectRight need to be moved to an override of the FlxG.overlap or FlxG.collide functions, but I don't know how to override that yet
// class ReflectLeft extends FlxFSMState<FlxSprite>
// {
// 	override public function enter(owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void
// 	{
// 		owner.animation.play("standing");
// 		owner.velocity.x = Math.abs(owner.velocity.x) * -1;
// 	}
// 	override public function update(elapsed:Float, owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void
// 	{
// 		owner.animation.play("standing");
// 		owner.velocity.x *= 0.99;
// 	}
// }
// class ReflectRight extends FlxFSMState<FlxSprite>
// {
// 	override public function enter(owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void
// 	{
// 		owner.animation.play("standing");
// 		owner.velocity.x = Math.abs(owner.velocity.x);
// 	}
// 	override public function update(elapsed:Float, owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void
// 	{
// 		owner.animation.play("standing");
// 		owner.velocity.x *= 0.99;
// 	}
// }
