package myobjects
{
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.core.StarlingState;
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Hero;
	import com.citrusengine.view.CitrusView;
	import com.citrusengine.view.ISpriteView;
	import com.citrusengine.view.starlingview.StarlingView;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class BoxManager
	{
		private var state:StarlingState;

		private var objectsBox2D:Vector.<CitrusObject> ;
		private var _parallax:int=1;
		private var _followMe:ISpriteView;
		private var _ce:CitrusEngine;

		private var currentBox2DObject:Box2DPhysicsObject;
		// timer to call updates, every second should be fine
		private var _timer:Timer
		public function BoxManager()
		{
		}
		public function initialize(state:StarlingState,_followMe:ISpriteView):void{
			this.state=state;
			this._followMe=_followMe;
			_ce = CitrusEngine.getInstance();
			objectsBox2D=state.getObjectsByType(Box2DPhysicsObject);
			//startTimer();
		}
		public function startTimer():void{
			 
			if(_timer) return;
			
			_timer= new Timer(1000);
			// gather nearby to player
			onTimer();
			
			// start up the timer
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		private function onTimer(e:TimerEvent = null):void {
			if(!objectsBox2D) return ;
			// loop through box physics
			//trace(this+ "--------------------------------------   " );
			var d:Number;
			var numInRam:uint = 0;
			var viewRootX:Number = StarlingView(_ce.state.view).viewRoot.x;
			var viewRootY:Number = StarlingView(_ce.state.view).viewRoot.y;
			
			var ll:uint = objectsBox2D.length;
			for (var t:uint = 0; t < ll; t ++) {
				// get a tile
				currentBox2DObject =(objectsBox2D[t] as Box2DPhysicsObject);
				// check distance between tile and hero
				d = DistanceTwoPoints(currentBox2DObject.x + (-viewRootX * (1 - _parallax)) + (currentBox2DObject.width >> 1), _followMe.x, currentBox2DObject.y + (-viewRootY * (1 - _parallax)) + (currentBox2DObject.height >> 1), _followMe.y);
				//trace(this+ " d:  "+d+" i: "+t+"   "+currentBox2DObject);
				// check if it is close enough to load in
				if (d < (Math.max(currentBox2DObject.width, currentBox2DObject.height)) * (1.9 / _parallax)+800) {
					if (!currentBox2DObject.body) {
						 
						currentBox2DObject.initialize();
						trace(this+"initialize Box "+	currentBox2DObject +" "+t);
					}
					
					
					// otherwise, check if it is far enough to dispose
				} else if (d > (Math.max(currentBox2DObject.width, currentBox2DObject.height)) * (1.9 / _parallax)+800) {
					if (currentBox2DObject.body) {
						 currentBox2DObject.destroyPhysics();
						 trace(this+"destory Box "+	currentBox2DObject +" "+t);
					}
				}
				
				 
			}
		}
		
		private function DistanceTwoPoints(x1:Number, x2:Number,  y1:Number, y2:Number):Number {
			
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			return Math.sqrt(dx * dx + dy * dy);
		}
	}
}