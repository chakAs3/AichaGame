package myobjects
{
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Missile;
	
	public class BallMonkey extends Missile
	{
		public function BallMonkey(name:String, params:Object=null)
		{
			super(name, params);
			angle=90;
			speed=0.2;
		}
		override public function update(timeDelta:Number):void
		{
			//super.update(timeDelta);
			
			updateAnimation();
		}
	}
}