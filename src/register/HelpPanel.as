package register
{
	import com.greensock.TweenLite;
	import com.scroller.Scrollbar;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	public class HelpPanel extends Sprite
	{
		public var btn_close:SimpleButton;
	 
		public var mc_container:MovieClip;
		public var masque:MovieClip;
		public var barscroller:MovieClip;
		private var view:*;
		public function HelpPanel(view:*=null)
		{
			super();
			this.view=view
			if(view){
				btn_close = view.getChildByName("btn_close");
				mc_container = view.getChildByName("mc_container");
				masque = view.getChildByName("masque");
				barscroller = view.getChildByName("barscroller");
				//setTimeout(createScroller,1000);
				view.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			}
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			btn_close.addEventListener(MouseEvent.CLICK,onClickClose);
			trace(this+" onAddedToStage " );
			createScroller();
			
		}
		
		protected function onClickClose(event:MouseEvent):void
		{
			if( !view ){
			  TweenLite.to(this,0.5,{y:700,alpha:0});
			}else{
				TweenLite.to(view,0.5,{y:700,alpha:0});
			}
			
		}
		private function createScroller():void
		{
			var sc:Scrollbar=new Scrollbar(mc_container,masque,barscroller.sub,barscroller.bar,masque,true,2);
			if(view){
				view.addChild(sc);
			}else{
				addChild(sc);
			}
			trace(this+" stage !!"+stage)
			sc.init();
			
		}
	}
}