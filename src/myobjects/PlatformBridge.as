package myobjects
{
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Hero;
	import com.citrusengine.objects.platformer.box2d.Platform;
	
	import flash.events.Event;
	
	import myobjects.enemies.FishEnemy;
	
	public class PlatformBridge extends Platform
	{
		public function PlatformBridge(name:String, params:Object=null)
		{
			super(name, params);
		}
		override protected function createFixture():void
		{
			super.createFixture();
			
			 
				_fixture.m_reportBeginContact = true;
				_fixture.m_reportEndContact = true;
				_fixture.addEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
				_fixture.addEventListener(ContactEvent.END_CONTACT, handleEndContact);
			
		}
		
		protected function handleEndContact(event:ContactEvent):void
		{
			var collider:Box2DPhysicsObject = event.other.GetBody().GetUserData();
			if(collider is Hero){
				this.offsetY=-8;
			}
			
			
		}
		
		protected function handleBeginContact(event:ContactEvent):void
		{
			var collider:Box2DPhysicsObject = event.other.GetBody().GetUserData();
			if(collider is Hero){
				this.offsetY=0;
			}
			if(collider is FishEnemy){
				event.contact.Disable();
			}
			
		}
		
	}
}