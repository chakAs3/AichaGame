package {

	import com.citrusengine.objects.platformer.box2d.Sensor;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.Color;

	/**
	 * @author Chakir
	 */
	public class Level2 extends ALevel {
		
		private var _timer:Timer;
		
		private var _bmpFontTF:TextField;

		public function Level2(level:MovieClip = null) {
			
			super(level);
		}
		
		override public function initialize():void {
			
			super.initialize();
			
			_timer = new Timer(3000);
			//_timer.addEventListener(TimerEvent.TIMER, _onTick);
			var endLevel:Sensor = Sensor(getObjectByName("endLevel"));
			if(endLevel)
			endLevel.onBeginContact.add(_changeLevel);
			trace(this+" initialize ")
		 
		}
			
		override protected function _handleLoadComplete():void {
			
			super._handleLoadComplete();
			
			 
		}

		private function _onTick(tEvt:TimerEvent):void {
			
			//if (_timer.currentCount == 2)
				//removeChild(_bmpFontTF);
			
			// PhysicsEditorObjects class is created by the software PhysicsEditor and its additional CitrusEngine template.
			// Muffins are not in front of everything due to the foreground group param set to 1 in the Level Editor, default is 0.
			//var muffin:PhysicsEditorObjects = new PhysicsEditorObjects("muffin", {peObject:"muffin", view:"muffin.png", registration:"topLeft", x:Math.random() * view.cameraBounds.width});
			//add(muffin);
		}

		override public function destroy():void {
			
			_timer.removeEventListener(TimerEvent.TIMER, _onTick);
			_timer.stop();
			_timer = null;
			
			trace(this+" level2 destroy ")
			
			super.destroy();
		}
	}
}
