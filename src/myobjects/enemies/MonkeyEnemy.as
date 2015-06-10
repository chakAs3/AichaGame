package myobjects.enemies
{
	import com.citrusengine.objects.platformer.box2d.Baddy;
	import com.citrusengine.objects.platformer.box2d.Hero;
	import com.citrusengine.objects.platformer.box2d.Sensor;
	
	import flash.events.TimerEvent;
	import flash.net.drm.AddToDeviceGroupSetting;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import myobjects.BallMonkey;
	import myobjects.rewards.Supercoin;
	
	import org.osmf.events.TimeEvent;
	
	public class MonkeyEnemy extends Sensor
	{

		private var _firing:Boolean;

		private var timer:Timer;

		private var hero:Hero;
		
		public var startingDirection:String;
		public var lifes:int=4;
		public var enemyKillVelocity:int=300;
		
		public var speedBall:Number=3;
		
		public var delay:Number=900;
		
		public function MonkeyEnemy(name:String, params:Object=null)
		{
			super(name, params);
			trace(this+" delay "+ delay );
			
		}
		override public function initialize(data:Object=null):void{
			super.initialize(data);
			setTimeout(startFire,delay+4000 ); 
		}
		
		public function startFire():void{
			timer=new Timer(2000);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
			hero=_ce.state.getFirstObjectByType(Hero) as Hero;
			_firing=true;
			_fire();
		}
		 
		override public function update(timeDelta:Number):void
		{
			//super.update(timeDelta);
			
			if(hero){
				if(Math.abs(hero.x-this.x) <= 40 ){
					//_fire();
				}
			}
			
			updateAnimation();
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			_firing=true;
			_fire()
			
		}
		
		private function _fire():void
		{
			
			
			_ce.state.add(new BallMonkey("BallMonkey", {x:x+4 , y:y+80, group:group, width:20, height:20, offsetY:0, speed:speedBall, angle:90, explodeDuration:400, fuseDuration:10500, view:"levels/common/bazani_spr.swf"}));
			setTimeout(function(){_firing=false },900);
			
		}
		protected function updateAnimation():void
		{
			 
			if(_firing)
				_animation = "shoot";
			else	
				_animation = "idle";
		}
		override public function destroy():void
		{
			super.destroy();
			if(timer){
				timer.stop();
				timer=null;
			}
		}
	}
}