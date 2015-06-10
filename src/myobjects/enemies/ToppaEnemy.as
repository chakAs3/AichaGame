package myobjects.enemies
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Baddy;
	import com.citrusengine.objects.platformer.box2d.Platform;
	
	import myobjects.NoteMissile;
	
	public class ToppaEnemy extends Baddy
	{
		
		[Inspectable(defaultValue="3")] 
		public var lifes:int=3;
		
		public function ToppaEnemy(name:String, params:Object=null)
		{
			super(name, params);
			hurtDuration=3000;
		}
		override protected function handleBeginContact(e:ContactEvent):void
		{
			super.handleBeginContact(e);
			var collider:Box2DPhysicsObject = e.other.GetBody().GetUserData();
			
			if (collider is NoteMissile ){
				lifes--
				if(lifes<=0)	{
					
					if(!_hurt){
						
						_body.SetLinearVelocity(new V2(0,-3)) 
						e.contact.Disable();
						_ce.gameData.score+=100;
						MyGameData(_ce.gameData).enemies_score+=100;
					};
					hurt();
					if(_hurt)
						e.contact.Disable();
				}
				
			}else{
				if(_hurt)
					e.contact.Disable();	
			}
			if( collider is Baddy ){
				e.contact.Disable();
			}
			
		}
		
		override protected function handleSensorBeginContact(e:ContactEvent):void
		{
			if (_body.GetLinearVelocity().x < 0 && e.fixture == _rightSensorFixture)
				return;
			
			if (_body.GetLinearVelocity().x > 0 && e.fixture == _leftSensorFixture)
				return;
			
			var collider:Box2DPhysicsObject = e.other.GetBody().GetUserData();
			if (collider is Platform)
			{
				turnAround();
			}
			
		}
		
		public function reverse():void{
			_inverted = !_inverted ;
		}
	}
}