package myobjects
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.MovingPlatform;
	import com.citrusengine.objects.platformer.box2d.Platform;
	import com.citrusengine.objects.platformer.box2d.Sensor;
	
	public class MyMovingPlateform extends MovingPlatform
	{
		public function MyMovingPlateform(name:String, params:Object=null)
		{
			super(name, params);
		}
		override public function update(timeDelta:Number):void
		{
			//super.update(timeDelta);
			
			var velocity:V2 = _body.GetLinearVelocity();
			
			if ((waitForPassenger && _passengers.length == 0) || !enabled)
			{
				//Platform should not move
				velocity.zero();
			}
			else
			{
				//Move the platform according to its destination
				
				//Turn around when they pass their left/right bounds
				 
				
				var velocity:V2 = _body.GetLinearVelocity();
				 
					if (_forward)
						velocity.x = -speed;
					else
						velocity.x = speed;
				 
			}
			
			_body.SetLinearVelocity(velocity);
		}
		override protected function handleBeginContact(e:ContactEvent):void
		{
			super.handleBeginContact(e);
			trace(this+" handleBeginContact "+collider)
			var collider:Box2DPhysicsObject = e.other.GetBody().GetUserData();
			trace(this+" handleBeginContact "+collider );
			
		}
		
		public function turnAround():void
		{
			_forward = !_forward ;
			
			
		}
	}
}