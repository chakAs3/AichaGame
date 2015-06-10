package myobjects.enemies
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Baddy;
	import com.citrusengine.objects.platformer.box2d.Platform;
	import com.citrusengine.physics.PhysicsCollisionCategories;
	
	import flash.utils.getTimer;
	
	import myobjects.NoteMissile;
	
	public class FlyEnemy extends  Baddy
	{
		private var counter:int;
		private var _sin:Boolean;
		private var _exploded:Boolean;
		
		[Inspectable(defaultValue="3")] 
		public var lifes:int=3;
		
		public function FlyEnemy(name:String, params:Object=null)
		{
			super(name, params);
			counter=0
			hurtDuration=1000;
		}
		override public function update(timeDelta:Number):void {
			
			/*if (!_exploded)
			_body.SetLinearVelocity(_velocity);
			else
			_body.SetLinearVelocity(new V2());
			*/
			super.update(timeDelta);
			if(!_body) return ;
			if(!_hurt){
			var removeGravity:V2 = new V2();
			removeGravity.subtract(_box2D.world.GetGravity());
			removeGravity.multiplyN(body.GetMass());
			
			_body.ApplyForce(removeGravity, _body.GetWorldCenter());
			
			var _velocity:V2=_body.GetLinearVelocity();
			 
			 
			var t:int=counter++;
			
			if(t % 50 == 0 )	 {	 
				_sin=!_sin
				if(_sin){
					_velocity.y=-1;
					_body.SetLinearVelocity(_velocity);
				}else{
					_velocity.y=1;
					_body.SetLinearVelocity(_velocity);
				}
			}
			}
			//if (x > 480)
			//kill = true;
			updateAnimation();
		}
		
		override protected function updateAnimation():void
		{
			if (_hurt)
				_animation = "die_enemy";
			else
				_animation = "idle";
		}
		override protected function handleBeginContact(e:ContactEvent):void
		{
			super.handleBeginContact(e);
			var collider:Box2DPhysicsObject = e.other.GetBody().GetUserData();
			if( collider is Baddy ){
				e.contact.Disable();
			}
			if (collider is NoteMissile ){
				lifes--
				if(lifes<=0)	{
					
					if(!_hurt){     
						_fixtureDef.filter.maskBits=PhysicsCollisionCategories.GetNone();
						_body.SetLinearVelocity(new V2(0,-3)) 
						e.contact.Disable();
						_ce.gameData.score+=150;
						MyGameData(_ce.gameData).enemies_score+=150;
					};
					trace(this+" hurt() ");
					hurt();
					if(_hurt)
						e.contact.Disable();
				}
				
			}else{
				if(_hurt)
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