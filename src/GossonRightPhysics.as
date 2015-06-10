package {

    import Box2DAS.Collision.Shapes.b2PolygonShape;
    import Box2DAS.Common.V2;
    
    
    import com.citrusengine.objects.platformer.box2d.Platform;

	/**
	 * @author Aymeric
	 * <p>This is a class created by the software http://www.physicseditor.de/</p>
	 * <p>Just select the CitrusEngine template, upload your png picture, set polygons and export.</p>
	 * <p>Be careful, the registration point is topLeft !</p>
	 * @param peObject : the name of the png file
	 */
    public class GossonRightPhysics extends Platform {
		
		[Inspectable(defaultValue="")]
		public var peObject:String = "";

		private var _tab:Array;

		public function GossonRightPhysics(name:String, params:Object = null) {

			super(name, params);
		}

		override public function destroy():void {

			super.destroy();
		}

		override public function update(timeDelta:Number):void {

			super.update(timeDelta);
		}

		override protected function defineFixture():void {
			
			super.defineFixture();
			
			_createVertices();

			_fixtureDef.density = _getDensity();
			_fixtureDef.friction = _getFriction();
			_fixtureDef.restitution = _getRestitution();
			
			for (var i:uint = 0; i < _tab.length; ++i) {
				var polygonShape:b2PolygonShape = new b2PolygonShape();
				polygonShape.Set(_tab[i]);
				_fixtureDef.shape = polygonShape;

				body.CreateFixture(_fixtureDef);
			}
		}
		
        protected function _createVertices():void {
			
			_tab = [];
			var vertices:Vector.<V2> = new Vector.<V2>();

			switch (peObject) {
				
				case "right ghossn2":
											
			        vertices.push(new V2(44/_box2D.scale, 54/_box2D.scale));
					vertices.push(new V2(153/_box2D.scale, 48/_box2D.scale));
					vertices.push(new V2(20/_box2D.scale, 121/_box2D.scale));
					vertices.push(new V2(2/_box2D.scale, 77/_box2D.scale));
					
					_tab.push(vertices);
					vertices = new Vector.<V2>();
											
			        vertices.push(new V2(281/_box2D.scale, 4/_box2D.scale));
					vertices.push(new V2(20/_box2D.scale, 121/_box2D.scale));
					vertices.push(new V2(153/_box2D.scale, 48/_box2D.scale));
					vertices.push(new V2(232/_box2D.scale, 9/_box2D.scale));
					
					_tab.push(vertices);
					
					break;
			
			}
		}

		protected function _getDensity():Number {

			switch (peObject) {
				
				case "right ghossn2":
					return 1;
					break;
			
			}

			return 1;
		}
		
		protected function _getFriction():Number {
			
			switch (peObject) {
				
				case "right ghossn2":
					return 1;
					break;
			
			}

			return 0.6;
		}
		
		protected function _getRestitution():Number {
			
			switch (peObject) {
				
				case "right ghossn2":
					return 0.3;
					break;
			
			}

			return 0.3;
		}
	}
}
