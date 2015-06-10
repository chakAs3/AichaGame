package register.ui 
{
	import flash.utils.setTimeout;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import com.greensock.*;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ©haki®
	 */
	public class EToggleButton extends Sprite
	{
		
		public var selected:Boolean;
		public var etatsText:Array=["On","Off"];
		public var colors:Array=[0xFFFFFF,0xD39C00];
		
		public var toogleMode:Boolean=false;
		
		public var mc_icone:MovieClip;
		public var mc_fond:MovieClip;
		
		public var fond_button:Sprite;
		
		//public var txt_label:TextField
		
		public function EToggleButton() 
		{
			 addEventListener(MouseEvent.ROLL_OVER,onMOver);
			 addEventListener(MouseEvent.ROLL_OUT,onMOut);
			 
			 addEventListener(MouseEvent.CLICK,onMClick);
			 
			 setTimeout(onMOut, 1000,null)//onMOut(null);
			 buttonMode = true;
			 mouseChildren = false;
			if(mc_icone) 
		   	mc_icone.stop();
			 
			 //if (txt_label);
			 //txt_label.embedFonts = true;
		}
		
		private function onMClick(e:MouseEvent):void 
		{
			if(!toogleMode) return;
			setEtat(!selected);
			dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
			
			
			
		}
		public function changeColors():void {
			
			var er:ERectange=new ERectange(mc_fond.width, mc_fond.height, colors[0], colors[1], true, null, 6);
			var child:DisplayObject = mc_fond.removeChildAt(0);
			er.x = child.x;
			er.y = child.y;
			mc_fond.addChild(er);
			//txt_label.textColor = 0xFC0000;
		}
		
		private function onMOut(e:MouseEvent):void 
		{
			if(mc_icone)
			TweenMax.to(mc_icone, 0.3, { tint:colors[0] } )
			if(fond_button)
			TweenLite.to(fond_button,0.5,{alpha:0.5})
			//TweenLite.to(mc_rond,0.5,{width:39,height:39,x:-19.5,y:-19.5,ease:Bounce.easeOut})
			if (mc_fond) {
				mc_fond.rotation = 0;
			}
		}
		
		private function onMOver(e:MouseEvent):void 
		{
			if(mc_icone){
			TweenMax.to(mc_icone, 0.3, { tint:colors[1] } )
			
			trace(this+ " Change tint ")
			}
			if(fond_button)
			TweenLite.to(fond_button,0.5,{alpha:1})
			//TweenLite.to(mc_rond,0.5,{width:35,height:35,x:-17.5,y:-17.5,ease:Bounce.easeOut})
			if (mc_fond) {
				mc_fond.rotation = 180;
			}
		}
		public function setEtat(bool:Boolean):void{
			selected=bool
			if(selected){
				//setText(etatsText[1]);
				mc_icone.gotoAndStop(2)
			}else{
				//setText(etatsText[0]);
				mc_icone.gotoAndStop(1)
			}
		}
		
	}
	
}