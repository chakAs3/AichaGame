package myobjects.ui
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import myobjects.model.vo.LevelScore;
	
	public class LevelItem extends Sprite
	{
		private var _view:*;
		 
		public function LevelItem(view:*)
		{
			super();
			this._view=view;
			view.mc_fruit.gotoAndStop(2);
			view.mc_letters.gotoAndStop(2);
			view.mc_supercoin.gotoAndStop(2);
			view.mc_num.gotoAndStop(1);
			//view.mouseChildren=false;
			//view.buttonMode=true;
			
			TweenLite.to(view.txt_title,0,{alpha:0,y:0});
			if(!(view.btn_start).hasEventListener(MouseEvent.ROLL_OVER)){
			 (view.btn_start).addEventListener(MouseEvent.ROLL_OVER,onImageOver);
			 (view.btn_start).addEventListener(MouseEvent.ROLL_OUT,onImageOut);
			}
			
		}
		
		protected function onImageOut(event:MouseEvent):void
		{
			TweenLite.to(view.txt_title,0.5,{alpha:0,y:0,ease:Strong.easeOut});
			
		}
		
		public function get view():*
		{
			return _view;
		}

		public function setData(param0:LevelScore):void
		{
			view.num=param0.id;
			view.txt_score.text=param0.score+" pts";
			view.txt_title.text=param0.name +"";
			view.mc_num.txt_num.text=param0.id;
			view.mc_black.visible = !param0.active
			view.mc_num.gotoAndStop(param0.active?1:2);
			view.mc_image.removeChildAt(0);
			if(param0.active){
				if(param0.star_fruit)
					view.mc_fruit.gotoAndStop(1);
				if(param0.star_letters)
					view.mc_letters.gotoAndStop(1);
				if(param0.star_super)
					view.mc_supercoin.gotoAndStop(1);
					
			}
			
			
			
		}
		
		protected function onImageOver(event:MouseEvent):void
		{
			TweenLite.to(view.txt_title,0.5,{alpha:1,y:-30,ease:Strong.easeOut});
			trace(this+"over !!!")
		}
	}
}