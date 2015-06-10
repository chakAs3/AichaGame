
package com.ammaria.xml
{
	
	/**
	 * ...
	 * @author ©haki®
	 */
	 
	 
 
	
	 
	
	import com.ammaria.xml.events.LoadEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.*;

	public class SendFriends extends EventDispatcher
	{
		private var ul:URLLoader;
		private var ur:URLRequest;
		private var urv:URLVariables;	
		public var SCORE_URL:String="services/invitation.php";//"services/getfriendsapp.php";
		public function SendFriends(objet:Object) 
		{
			ul = new URLLoader();
			ur = new URLRequest();
			urv= new URLVariables();
			
			 
			
			urv.email = objet.email;
			urv.friends = objet.friends;
			
			 
			ur.method = URLRequestMethod.POST;
			ur.data = urv;
			
			
			ur.url =SCORE_URL
			
			ul.addEventListener(Event.COMPLETE, onXmlLoaded);
			ul.load(ur);
			 
		}
		
		private function onXmlLoaded(e:Event):void 
		{
			var xml:XML = new XML(e.target.data);
		 
		//	var list:Array=LoadInfo.parseXml(xml);
			var event:LoadEvent=new LoadEvent(LoadEvent.RESULTAS_RESPONSE);
			
			var object:Object=new Object(); 
			object.scoreInvite=xml;
			event.load_data=object;
			dispatchEvent(event);
		}
		
	}
	
}