package myobjects.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import myobjects.GameEvent;
	
	public class SelectMenu extends Sprite
	{
		public var ids:Array=[6,0,4,2,3,5,1,6,0,3,5,1] ;
		public var angle:int=0;
		public var unit:int=30;
		public var cerclePersonnage:MovieClip;
		public function SelectMenu()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			init_();
			
		}
		
		private function init_():void
		{
			visible=false;
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onMKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onMKeyUp);
			
		}
		
		protected function onMKeyUp(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.C){
				var e:GameEvent=new GameEvent(GameEvent.SELECT_HERO,true);
				e.data=ids[getIndexFromAngle()];
				dispatchEvent(e);
				visible=false;
			}
			
		}
		
		protected function onMKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode==Keyboard.LEFT && visible){
				angle+=unit;
				cerclePersonnage.rotation=angle
				
			}else if(event.keyCode==Keyboard.RIGHT && visible ){
				angle-=unit;
				cerclePersonnage.rotation=angle;
				
				 
			}else if(event.keyCode==Keyboard.C && !visible){
				
				var e:GameEvent=new GameEvent(GameEvent.SHOW_MENU,true); 
				dispatchEvent(e);
				visible=true;
				
			}
			
			
		}
		
		private function getIndexFromAngle():int
		{
			
			var id:int=-int(angle/unit);
			 
			id=(id%ids.length)>= 0 ? (id%ids.length) : (ids.length+ (id%ids.length))
			
			trace(this+" id :"+id);
			return id;
		}
		public function show(visible:Boolean):void{
			this.visible=visible;
		}
		
		protected function onMKeyUP(event:MouseEvent):void
		{
			
			
		}
	}
}