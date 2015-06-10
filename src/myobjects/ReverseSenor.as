package myobjects
{
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Sensor;
	
	import myobjects.enemies.FlyEnemy;
	import myobjects.enemies.ToppaEnemy;
	
	public class ReverseSenor extends Sensor
	{
		public function ReverseSenor(name:String, params:Object=null)
		{
			super(name, params);
		}
		override protected function handleBeginContact(e:ContactEvent):void
		{
			super.handleBeginContact(e); 
			//trace(this+" handleBeginContact "+collider);
			var collider:Box2DPhysicsObject = e.other.GetBody().GetUserData();
			 
			if( collider is ToppaEnemy)
			{
				(collider as ToppaEnemy).reverse();
			}
			if( collider is FlyEnemy ){
				(collider as FlyEnemy).reverse();
			}
		}
	}
}