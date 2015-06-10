package myobjects
{

	import Box2DAS.Collision.Shapes.b2MassData;
	
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.platformer.box2d.Crate;
	import com.citrusengine.physics.PhysicsCollisionCategories;
	
	import flash.display.MovieClip;
	
	/**
	 * A very simple physics object. I just needed to add bullet mode and zero restitution
	 * to make it more stable, otherwise it gets very jittery. 
	 */	
	public class MyCrate extends  Crate
	{
		private var canMove:Boolean;
		 
		public function MyCrate(name:String, params:Object=null)
		{
			super(name, params);
			offsetX=8;
			offsetY=-6;
		}
		override protected function defineFixture():void
		{
			super.defineFixture();
			_fixtureDef.density = 10//0.1;	
			_fixtureDef.restitution = 0;
			_fixtureDef.filter.categoryBits = PhysicsCollisionCategories.Get("Items");
			_fixtureDef.filter.maskBits = PhysicsCollisionCategories.GetAll();
		}
		override public function update(timeDelta:Number):void{
			if(y> 1700){
				kill=true;
			}
		}
		public function canMoved(move:Boolean):void{
			//_fixtureDef.density = move ? 0.1 : 10 ;
		//	createFixture();
			if(canMove==move) return ;
			this.canMove=move
			_fixture.SetDensity( move ? 0.1 : 10 );
			_fixture.SetFriction(move ? 0 : 1);
		}
	}
}