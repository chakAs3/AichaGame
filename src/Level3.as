package
{
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.platformer.box2d.Hero;
	import com.citrusengine.objects.platformer.box2d.Sensor;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	
	public class Level3 extends ALevel
	{
		public function Level3(level:MovieClip=null)
		{
			super(level);
		}
		override public function initialize():void {
			
			super.initialize();
			
		 
			//_timer.addEventListener(TimerEvent.TIMER, _onTick);

			var endLevel:Sensor = Sensor(getObjectByName("endLevel"));

			if(endLevel)
			endLevel.onBeginContact.add(_changeLevel);
			
		}
		override protected function _changeLevel(cEvt:ContactEvent):void {
			
			
			if (cEvt.other.GetBody().GetUserData() is Hero) {

				lvlEnded.dispatch("end");
				SoundManager.getInstance().stopSound("ambiance");
				(cEvt.other.GetBody().GetUserData() as Hero).controlsEnabled=false;

			}
		}
		
		override protected function _handleLoadComplete():void {
			
			super._handleLoadComplete();
			
			 
		}
		
		 
		
		override public function destroy():void {
			
			super.destroy();
		}
	}
}