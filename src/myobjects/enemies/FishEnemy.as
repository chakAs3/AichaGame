package myobjects.enemies
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Baddy;
	import com.citrusengine.objects.platformer.box2d.Hero;
	import com.citrusengine.objects.platformer.box2d.MovingPlatform;
	import com.citrusengine.objects.platformer.box2d.Platform;
	import com.citrusengine.physics.PhysicsCollisionCategories;
	import com.citrusengine.utils.Box2DShapeMaker;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import myobjects.NoteMissile;
	import myobjects.sparks.Sparks;
	
	public class FishEnemy extends Box2DPhysicsObject
	{
		
		[Inspectable(defaultValue="3")] 
		public var delay:int=4000;
		
		[Inspectable(defaultValue="12")] 
		public var jumpHeight:int=12;
		
		private var _jump:Boolean;

		private var timer:Timer;
		
		public function FishEnemy(name:String, params:Object=null)
		{
			super(name, params);
			//hurtDuration=3000;
			timer=new Timer(delay);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
			//speed=0.1;
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			 
			//    trace(this+" onTimer  :")
			 
			_jump=true ;
			//   setTimeout(addSplash,100);
		   //	_body.ApplyForce(new V2(-3,-20), _body.GetWorldCenter());
			
		}
		
		override protected function defineBody():void
		{
			super.defineBody();
			_bodyDef.fixedRotation = true;
			_bodyDef.allowSleep = false;
		}
		
		override protected function createShape():void
		{
			_shape = Box2DShapeMaker.BeveledRect(_width, _height, 0.1);
		}
		
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.friction = 12;
			_fixtureDef.density = 160 ;
			_fixtureDef.restitution = 0;
			//_fixtureDef.isSensor=true;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("BadGuys");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAllExcept("BadGuys")//("GoodGuys","Level");
		}
		
		override protected function createFixture():void
		{
			super.createFixture();
			_fixture.m_reportPreSolve = true;
			_fixture.m_reportBeginContact = true;
			_fixture.m_reportEndContact = true;
			//_fixture.addEventListener(ContactEvent.PRE_SOLVE, handlePreSolve);
			_fixture.addEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
		    //_fixture.addEventListener(ContactEvent.END_CONTACT, handleEndContact);
		}
		protected function handleBeginContact(event:ContactEvent):void
		{
			var collider:Box2DPhysicsObject = event.other.GetBody().GetUserData();
			if(collider is Hero){
				event.contact.Disable();
			}
			if(collider is MovingPlatform){
				event.contact.Disable();
			}
			
		}
		override public function update(timeDelta:Number):void {
			
			 
			super.update(timeDelta);
			if(!_body) return ;
			 
			var _velocity:V2=_body.GetLinearVelocity();
			
			
			if(_jump ){
				//trace(this+" _jump ()")
				_velocity.y=-jumpHeight;
				
			}
			_body.SetLinearVelocity(_velocity);	
			_jump=false; 
			
			if(_velocity.y > 2 ){
				rotation=-40
			}else if(_velocity.y < - 6 ){
				rotation=0;
			}
			//visible= _velocity.y != 0 ;
			updateAnimation();
		}
		
		 
		 
		protected function updateAnimation():void
		{
			 
				_animation = "idle";
		}
		 
		public function reverse():void{
			_inverted = !_inverted ;
		}
	}
}