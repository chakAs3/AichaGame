package emagin.xml 
{

	import emagin.data.EventData;
	import emagin.xml.events.LoadEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	
	/**
	 * ...
	 * @author Chakir
	 */
	public class LoadEvenements extends EventDispatcher
	{
		public var URL_GET:String;
		
		private var ul:URLLoader;
		private var ur:URLRequest;
		private var urv:URLVariables;	
		public function LoadEvenements(chemin:String) 
		{
			URL_GET 	= chemin;
			
			//ul = new URLLoader();
			//ur = new URLRequest();
			//urv= new URLVariables();
			//
		   //
			//
			//ur.method = URLRequestMethod.POST;
			//ur.data = urv;
			//
			//ur.url = URL_GET ;
			//
			//ul.addEventListener(Event.COMPLETE, onXmlLoaded);
			//ul.load(ur);
			
			var u:URLLoader = new URLLoader();
			u.addEventListener(Event.COMPLETE, onXmlLoaded);
			try{
			u.load(new URLRequest(chemin));
            }catch(err:Error){
				
			}
		}
		private function onXmlLoaded(e:Event):void {
			var xml:XML = new XML(e.target.data);
			
			
			
			var ar:Array = new Array();
			for each (var xf:XML in xml.event) {
				var mediaFile:EventData=new EventData();
				mediaFile.setDataFromXml(xf);
				ar.push(mediaFile);
			}
			
			var o:Object = new Object();
			//o.user_id = xml.@id.toString();
			o.events_list = ar;

			
			var loev:LoadEvent = new LoadEvent(LoadEvent.LOAD_EVENTS);
			loev.load_data = o;
			dispatchEvent(loev);
		}
		
	}
	
}