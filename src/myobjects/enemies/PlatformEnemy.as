package myobjects.enemies
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;
	
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.Box2DPhysicsObject;
	
	import flash.utils.setTimeout;
	
	public class PlatformEnemy extends Box2DPhysicsObject
	{
		protected var _start:MathVector = new MathVector();
		protected var _end:MathVector = new MathVector();
		protected var _forward:Boolean = true;
		private var enabled:Boolean;
		
		[Inspectable(defaultValue="1")]
		public var speed:Number = 1;
		
		[Inspectable(defaultValue="1")]
		public var delay:Number = 1000;
		
		public function PlatformEnemy(name:String, params:Object=null)
		{
			super(name, params);
			setTimeout(function(){ enabled=true;  },delay);
		}
		override protected function defineBody():void
		{
			super.defineBody();
			_bodyDef.type = b2Body.b2_kinematicBody; //Kinematic bodies don't respond to outside forces, only velocity.
			_bodyDef.allowSleep = false;
			 
		}
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.isSensor = true;
		}
		override protected function createFixture():void
		{
			super.createFixture();
			_fixture.m_reportBeginContact = true;
			_fixture.m_reportEndContact = true;
			_fixture.addEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
			//_fixture.addEventListener(ContactEvent.END_CONTACT, handleEndContact);
		}
		/**
		 * The initial starting X position of the MovingPlatform, and the place it returns to when it reaches
		 * the end destination.
		 */		
		public function get startX():Number
		{
			return _start.x * _box2D.scale;
		}
		
		[Inspectable(defaultValue="0")]
		public function set startX(value:Number):void
		{
			_start.x = value / _box2D.scale;
		}
		
		/**
		 * The initial starting Y position of the MovingPlatform, and the place it returns to when it reaches
		 * the end destination.
		 */		
		public function get startY():Number
		{
			return _start.y * _box2D.scale;
		}
		
		[Inspectable(defaultValue="0")]
		public function set startY(value:Number):void
		{
			_start.y = value / _box2D.scale;
		}
		
		/**
		 * The ending X position of the MovingPlatform.
		 */		
		public function get endX():Number
		{
			return _end.x * _box2D.scale;
		}
		
		[Inspectable(defaultValue="0")]
		public function set endX(value:Number):void
		{
			_end.x = value / _box2D.scale;
		}
		
		/**
		 * The ending Y position of the MovingPlatform.
		 */		
		public function get endY():Number
		{
			return _end.y * _box2D.scale;
		}
		
		[Inspectable(defaultValue="0")]
		public function set endY(value:Number):void
		{
			_end.y = value / _box2D.scale;
		}
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			var velocity:V2 = _body.GetLinearVelocity();
			
			if (!enabled)
			{
				//Platform should not move
				velocity.zero();
			}
			else
			{
				//Move the platform according to its destination
				
				var destination:V2 = new V2(_end.x, _end.y);
				if (!_forward)
					destination = new V2(_start.x, _start.y);
				
				velocity = destination.subtract(_body.GetPosition());
				
				if (velocity.length() > speed / 30)
				{
					//Still has further to go. Normalize the velocity to the max speed
					velocity = velocity.normalize(speed);
				}
				else
				{
					//Destination is very close. Switch the travelling direction
					_forward = !_forward;
				}
			}
			
			_body.SetLinearVelocity(velocity);
		}
		
		protected function handleBeginContact(e:ContactEvent):void
		{
			 
		}
	}
}