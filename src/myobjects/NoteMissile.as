package myobjects {
	
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.objects.platformer.box2d.Missile;
	import com.citrusengine.physics.PhysicsCollisionCategories;
	
	import flash.utils.getTimer;

	//import com.citrusengine.physics.Box2DCollisionCategories;
	
	/**
	 * @author chakir
	 */
	public class NoteMissile extends Missile {
		private var counter:int=0;
		private var _sin:Boolean;
		
		public function NoteMissile(name:String, params:Object = null) {
			super(name, params);
			counter=0
		}
		
		override public function update(timeDelta:Number):void {
			
			/*if (!_exploded)
				_body.SetLinearVelocity(_velocity);
			else
				_body.SetLinearVelocity(new V2());
			*/
			super.update(timeDelta);
			var t:int=counter++;
			
			if(t % 25 == 0 )	 {	 
			    _sin=!_sin
				if(_sin){
					_velocity.y=-2;
				_body.SetLinearVelocity(_velocity);
				}else{
					_velocity.y=3;
				_body.SetLinearVelocity(_velocity);
				}
			}
			
			//if (x > 480)
				//kill = true;
		}
		
		override protected function handleBeginContact(cEvt:ContactEvent):void {
			explode();
		}
		
		override protected function defineBody():void {
			
			super.defineBody();
			
			_bodyDef.bullet = false;
			_bodyDef.allowSleep = true;
		}
		
		override protected function defineFixture():void {
			
			super.defineFixture();
			
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("Level");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAllExcept("Level");
		}
		
	}
}