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
    public class GossonPhysics extends Platform {
		
		[Inspectable(defaultValue="")]
		public var peObject:String = "";

		private var _tab:Array;

		public function GossonPhysics(name:String, params:Object = null) {

			super(name, params);
			registration="topLeft";
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
			
				case "left_ghossn":
											
			        vertices.push(new V2(164/_box2D.scale, 24/_box2D.scale));
					vertices.push(new V2(180/_box2D.scale, 10/_box2D.scale));
					vertices.push(new V2(229/_box2D.scale, 46/_box2D.scale));
					vertices.push(new V2(217/_box2D.scale, 129/_box2D.scale));
					
					_tab.push(vertices);
					vertices = new Vector.<V2>();
											
			        vertices.push(new V2(164/_box2D.scale, 24/_box2D.scale));
					vertices.push(new V2(5/_box2D.scale, 9/_box2D.scale));
					vertices.push(new V2(180/_box2D.scale, 10/_box2D.scale));
					
					_tab.push(vertices);
					
					break;
			
				case "left_ghossn2":
											
			        vertices.push(new V2(167/_box2D.scale, 72/_box2D.scale));
					vertices.push(new V2(116/_box2D.scale, 38/_box2D.scale));
					vertices.push(new V2(141/_box2D.scale, 17/_box2D.scale));
					
					_tab.push(vertices);
					vertices = new Vector.<V2>();
											
			        vertices.push(new V2(167/_box2D.scale, 72/_box2D.scale));
					vertices.push(new V2(6/_box2D.scale, 15/_box2D.scale));
					vertices.push(new V2(116/_box2D.scale, 38/_box2D.scale));
					
					_tab.push(vertices);
					
					break;
			
				case "right_ghossn":
											
			        vertices.push(new V2(27/_box2D.scale, 18/_box2D.scale));
					vertices.push(new V2(58/_box2D.scale, 38/_box2D.scale));
					vertices.push(new V2(34/_box2D.scale, 70/_box2D.scale));
					vertices.push(new V2(2/_box2D.scale, 61/_box2D.scale));
					
					_tab.push(vertices);
					vertices = new Vector.<V2>();
											
			        vertices.push(new V2(174/_box2D.scale, 18/_box2D.scale));
					vertices.push(new V2(318/_box2D.scale, 9/_box2D.scale));
					vertices.push(new V2(34/_box2D.scale, 70/_box2D.scale));
					vertices.push(new V2(58/_box2D.scale, 38/_box2D.scale));
					
					_tab.push(vertices);
					
					break;
			
				case "right_ghossn2":
											
			        vertices.push(new V2(52/_box2D.scale, 35/_box2D.scale));
					vertices.push(new V2(20/_box2D.scale, 82/_box2D.scale));
					vertices.push(new V2(23/_box2D.scale, 15/_box2D.scale));
					
					_tab.push(vertices);
					vertices = new Vector.<V2>();
											
			        vertices.push(new V2(20/_box2D.scale, 82/_box2D.scale));
					vertices.push(new V2(52/_box2D.scale, 35/_box2D.scale));
					vertices.push(new V2(199/_box2D.scale, 20/_box2D.scale));
					
					_tab.push(vertices);
					
					break;
			
			}
		}

		protected function _getDensity():Number {

			switch (peObject) {
				
			 
				case "left_ghossn":
					return 1;
					break;
			
				case "left_ghossn2":
					return 1;
					break;
			
				case "right_ghossn":
					return 1;
					break;
			
				case "right_ghossn2":
					return 1;
					break;
			
			}

			return 1;
		}
		
		protected function _getFriction():Number {
			
			switch (peObject) {
			 
				case "left_ghossn":
					return 1;
					break;
			
				case "left_ghossn2":
					return 1;
					break;
			
				case "right_ghossn":
					return 1;
					break;
			
				case "right_ghossn2":
					return 1;
					break;
			
			}

			return 0.6;
		}
		
		protected function _getRestitution():Number {
			
			switch (peObject) {
				
			 
			
				case "left_ghossn":
					return 0.3;
					break;
			
				case "left_ghossn2":
					return 0.3;
					break;
			
				case "right_ghossn":
					return 0.3;
					break;
			
				case "right_ghossn2":
					return 0.3;
					break;
			
			}

			return 0.3;
		}
	}
}
