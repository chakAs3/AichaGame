package {

	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.objects.platformer.box2d.Hero;
	import com.citrusengine.objects.platformer.box2d.Sensor;
	
	import flash.display.MovieClip;
	
	import starling.core.Starling;
	import starling.extensions.particles.ParticleDesignerPS;
	import starling.extensions.particles.ParticleSystem;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;

	/**
	 * @author Chakir
	 */
	public class Level1 extends ALevel {
		
		
		
		private var _bmpFontTF:TextField;

		public function Level1(level:MovieClip = null) {
			super(level);
		}

		override public function initialize():void {
			
			super.initialize();
			
		

			//_particleSystem = new ParticleDesignerPS(psconfig, psTexture);
			//_particleSystem.start();
			//Starling.juggler.add(_particleSystem);
			
			var endLevel:Sensor = Sensor(getObjectByName("endLevel"));
			if(endLevel)
			endLevel.onBeginContact.add(_changeLevel);
		//	endLevel.view = _particleSystem;
			
			_bmpFontTF = new TextField(500, 200, "Aicha environnement", "ArialMT");
			_bmpFontTF.fontSize = BitmapFont.NATIVE_SIZE;
			_bmpFontTF.color = Color.WHITE;
			_bmpFontTF.autoScale = true;
			_bmpFontTF.x = (stage.stageWidth - _bmpFontTF.width) / 2;
			_bmpFontTF.y = (stage.stageHeight - _bmpFontTF.height) / 2;
			
			addChild(_bmpFontTF);
			_bmpFontTF.visible = false;
			
			
			//var ghossn2:GossonRightPhysics = new GossonRightPhysics("ghossn2", {peObject:"right ghossn2", view:"levels/A2/right ghossn2.png", registration:"topLeft",y:690, x:200});
			//ghossn2.offsetY=-6;
			//add(ghossn2);
		
			/*
			var popUp:Sensor = Sensor(getObjectByName("popUp"));
			
			
			
			popUp.onBeginContact.add(_showPopUp);
			popUp.onEndContact.add(_hidePopUp);
			
			
			var popControl:Sensor = Sensor(getObjectByName("control")); 
			popControl.onBeginContact.add(_showControlPopUp);
			popControl.onEndContact.add(_hidePopUp);
			
			var popKfizou:Sensor = Sensor(getObjectByName("kfizou")); 
			popKfizou.onBeginContact.add(_showKfizouPopUp);
			popKfizou.onEndContact.add(_hidePopUp);*/
		}
		
		private function _showPopUp(cEvt:ContactEvent):void {
			
			if (cEvt.other.GetBody().GetUserData() is Hero) {
				_bmpFontTF.visible = true;
			}
		}
		
		private function _hidePopUp(cEvt:ContactEvent):void {
			
			if (cEvt.other.GetBody().GetUserData() is Hero) {
				_bmpFontTF.visible = false;
			}
		}
		
		
		private function _showControlPopUp(cEvt:ContactEvent):void {
			
			if (cEvt.other.GetBody().GetUserData() is Hero) {
				_bmpFontTF.text="Utilisez la touche controle pour changer de personnage";
				_bmpFontTF.visible = true;
			}
		}
		
		private function _showKfizouPopUp(cEvt:ContactEvent):void {
			
			if (cEvt.other.GetBody().GetUserData() is Hero) {
				_bmpFontTF.text="Kfizou a le pouvoir de sauter c'est le moment ideal pour l'utiliser ";
				_bmpFontTF.visible = true;
			}
		}
		
		 
		
		override public function destroy():void {

			 
			
			removeChild(_bmpFontTF);

			super.destroy();
		}

	}
}
