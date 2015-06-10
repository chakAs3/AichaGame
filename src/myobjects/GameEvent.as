package myobjects
{
	import flash.events.Event;
	
	public class GameEvent extends Event
	{
		public static const SHOW_MENU:String="SHOW_MENU";
		public static const SELECT_HERO:String="SELECT_HERO";
		public var data:*;
		public function GameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}