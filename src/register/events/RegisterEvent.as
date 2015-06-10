package register.events {

	import flash.events.Event;
	
	public class RegisterEvent extends Event {
		
	
		public static const LOAD_MEDIAS:String = "LoadEvent.LOAD_MEDIAS";
		public static const LOAD_REGISTER:String = "LoadEvent.LOAD_CONTACT";
		public static const VALIDATE_STEP1:String = "LoadEvent.VALIDATE_STEP1";
		 
		 
		public static const LOGIN_RESPONSE:String = "LoadEvent.LOGIN_RESPONSE";
		
		public static const CHANGE_PAGE:String = "LoadEvent.CHANGE_PAGE";
		 
		public var load_data:*;
		public static var LOAD_CLASSMENT:String= "LoadEvent.LOAD_CLASSMENT";
	 
		
		public function RegisterEvent(pEvent:String,data:*=null):void {
			super(pEvent,true);
			this.load_data=data;
		}
	};
	
};