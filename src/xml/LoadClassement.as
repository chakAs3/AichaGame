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
	
	public class LoadClassement extends EventDispatcher {
		
		private var u:URLLoader;
		private var CLASSEMENT_FORM_URL:String="services/classement.php";
		private var ur:URLRequest;
		private var urv:URLVariables;
		public function LoadClassement(path:String=null,objet:Object=null) {
			//super(target);
			if(path) CLASSEMENT_FORM_URL=path;
			load(CLASSEMENT_FORM_URL,objet)
		}
		public function load(path:String,objet:Object=null):void{
			u= new URLLoader();
			 
			ur = new URLRequest(path);
			urv= new URLVariables();
			
			
			if(objet){
			 urv.email = objet.email;
			 //urv.score = objet.score;
			}
			
			
			ur.method = URLRequestMethod.POST;
			ur.data = urv;
			u.addEventListener(Event.COMPLETE, onMediaDataLoaded);
			u.load(ur);
		}
		protected function onMediaDataLoaded(event:Event):void
		{
			// TODO recevoir les donnes txt des piece les convertis en Object , et dispatcher aux autre composant de l'application
			var list:Array=LoadClassement.parseXml(new XML(event.target.data));
			var eventLoad:LoadEvent=new LoadEvent( LoadEvent.LOAD_CLASSMENT);
			eventLoad.load_data=list;
			dispatchEvent(eventLoad);
		}
		
		/**
		 * fonction qui parse 
		 */
		public static function parseXml(xml : XML) : Array {
			var liste_cat : Array = [];
			var node : XML = null;
			var catnode : XML = null;
			
			 
			for each (var cat : XML in xml.periode) {
				var liste : Array = new Array();
				for each (var item in cat.item) {
					
				 
					liste.push({id:item.@id,user:item.user,score:item.score,current:item.@user});
					 
					
				}
			 
				liste_cat.push({id:cat.@id, label:cat.@label,lot:cat.@lot,items:liste,dateDebut:getDateFromString(cat.@debut),dateFin:getDateFromString(cat.@fin)});
			}
			return liste_cat;
		}
		public static function getDateFromString(str:String):Date
		{
			return new Date(str.split("-")[2],int(str.split("-")[1])-1,str.split("-")[0]);
		}
		
	}
}

