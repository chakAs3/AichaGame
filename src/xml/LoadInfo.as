package com.ammaria.xml {
	
	 
	
	import com.ammaria.xml.events.LoadEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * @author emagin
	 */
	
	public class LoadInfo extends EventDispatcher {
		
		private var u:URLLoader;
		private var SCORES_FORM_URL:String="services/profile.php";
		private var user:String
		public function LoadInfo(iduser:String) {
			 user=iduser
			load(SCORES_FORM_URL)
		}
		public function load(path:String):void{
			
			var ur:URLRequest = new URLRequest();
			var urv:URLVariables= new URLVariables();
			
			
			
			urv.email = user;
			u= new URLLoader();
			ur.method = URLRequestMethod.POST;
			ur.data = urv;
			
			
			ur.url = SCORES_FORM_URL;
			u.addEventListener(Event.COMPLETE, onMediaDataLoaded);
			u.load(ur);
		}
		protected function onMediaDataLoaded(event:Event):void
		{
			// recevoir les donnes txt des piece les convertis en Object , et dispatcher aux autre composant de l'application
			var list:Array=LoadInfo.parseXml(new XML(event.target.data));
			var eventLoad:LoadEvent=new LoadEvent(LoadEvent.LOAD_CONFIG);
			eventLoad.load_data=list;
			dispatchEvent(eventLoad);
		}
		
		/**
		 * fonction qui parse 
		 */
		public static function parseXml(xml : XML) : Array {
			var liste : Array = [];
			var node : XML = null;
			var catnode : XML = null;
			
			for each (node in xml.user) {
				
				liste.push({id:node.@id,score1:node.score1,score_invit:node.score_invit,invites:node.invites});
				
			}
			
			return liste;
		}
		
	}
}

