package myobjects.enemies
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Baddy;
	import com.citrusengine.objects.platformer.box2d.Hero;
	import com.citrusengine.physics.PhysicsCollisionCategories;
	
	import myobjects.AichaHero;
	import myobjects.NoteMissile;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	
	public class SerpentEnemy extends Baddy
	{
		[Inspectable(defaultValue="3")] 
		public var lifes:int=3;
		private var _hero:AichaHero ;
		public function SerpentEnemy(name:String, params:Object=null)
		{
			super(name, params);
			lifes=3;
			hurtDuration=3000;
			
			
		}
		override public function initialize(poolObjectParams:Object = null):void {
			
			super.initialize(poolObjectParams);
			_hero = AichaHero(_ce.state.getFirstObjectByType(Hero));
			 
		}
		override public function update(timeDelta:Number):void
		{
			 
			if( _hero ){
			    _inverted=(this.x-_hero.x)>0;
			} else {
				_hero = AichaHero(_ce.state.getFirstObjectByType(Hero));
			}
			 
			updateAnimation();
		}
		override protected function createFixture():void
		{
			_fixtureDef.density=10;
			_fixtureDef.friction=2;
			super.createFixture();
			
		}
		override protected function handleBeginContact(e:ContactEvent):void
		{
			super.handleBeginContact(e);
			var collider:Box2DPhysicsObject = e.other.GetBody().GetUserData();
			
			if (collider is NoteMissile ){
				lifes--
				if(lifes<=0)	{
					 
					if(!_hurt){
					   _fixtureDef.filter.maskBits=PhysicsCollisionCategories.GetNone();
					  // e.contact.Disable();
					  _body.SetLinearVelocity(new V2(0,-5)) ;
					  _ce.gameData.score+=50;
					  MyGameData(_ce.gameData).enemies_score+=50;
					};
				    hurt();
					if(_hurt)
						e.contact.Disable();
				}
				
			}else{
				if(_hurt)
					e.contact.Disable();	
			}
			
		}
		
		private function outAnimation():void
		{
			var tween:Tween = new Tween(this, 2.0, Transitions.EASE_OUT_BOUNCE);
			//tween.animate("x", this.x - 300);
			tween.animate("y", 640);
			tween.animate("rotation",Math.PI/2);
			// tween.onComplete=function():void{ kill = true;   } ; 
			//tween.fadeTo(0);    // equivalent to 'animate("alpha", 0)'
			Starling.juggler.add(tween); 
			
		}
		override protected function updateAnimation():void
		{
			if (_hurt)
				_animation = "die_enemy";
			else
				_animation = "idle";
		}
	}
}