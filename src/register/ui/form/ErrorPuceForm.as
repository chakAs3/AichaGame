package register.ui.form
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import register.ui.ERectange;
	
	/**
	 * ...
	 * @author ©haki®
	 */
	public class ErrorPuceForm extends MovieClip
	{
		public var mc_fond:Sprite
		
		public var txt_label:TextField;
		public var mc_icone:Sprite
		
		 
		private var _fondWidth:int=140;
		
		public var rond:int = 13;
		public function ErrorPuceForm() 
		{
			txt_label = new TextField();
			txt_label.autoSize = "right";
			txt_label.embedFonts = true;
			txt_label.antiAliasType="advanced";
			txt_label.defaultTextFormat = new TextFormat("Arial", 8,0xFFFFFF);
			txt_label.visible = false;
			
			addChild(txt_label);
			addEventListener(MouseEvent.ROLL_OVER, onMOver);
			addEventListener(MouseEvent.ROLL_OUT, onMOut);
			onMOut(null);
			
		}
		
		private function onMOut(e:MouseEvent):void 
		{
			TweenLite.to(this, 0.3, { fondWidth:14 } );
			TweenLite.to(mc_fond, 0.3, { x:0 } );
			txt_label.visible = false;
		}
		
		private function onMOver(e:MouseEvent):void 
		{
			TweenLite.to(this, 0.3, { fondWidth:txt_label.width+8+18 } );
			TweenLite.to(mc_fond, 0.3, { x:-txt_label.width-8 ,onComplete:function(){ txt_label.visible = true }} );
		}
		public function setText(str:String):void {
			txt_label.text = str.toUpperCase();
			txt_label.x = -2 - txt_label.width;
			txt_label.y=-1
		}
		
		public function get fondWidth():int { return _fondWidth; }
		
		public function set fondWidth(value:int):void 
		{
			_fondWidth = value;
			 
			
			var r:ERectange = new ERectange(value, 14, 0xCA1717,0xEB3A3A,   true, null, rond);
			if(mc_fond.numChildren)
			mc_fond.removeChildAt(0);
			
			mc_fond.addChild(r);
		}
		
		
	}
	
}