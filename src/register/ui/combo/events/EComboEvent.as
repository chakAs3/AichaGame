package register.ui.combo.events 
{
	 
	import flash.events.Event;
	
	import register.ui.combo.EComboItem;
	
	/**
	 * ...
	 * @author Chakir
	 */
	public class EComboEvent extends Event
	{
		public static const ITEM_SELECTED:String = "EComboEvent.ITEM_SELECTED";
		
		public var item:EComboItem;
		public function EComboEvent(pEvent:String,bubbles:Boolean):void {
			super(pEvent,bubbles);
		} 
		
	}
	
}