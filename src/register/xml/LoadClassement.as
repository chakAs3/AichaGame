package register.xml {
	
	 
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import myobjects.model.GameModel;
	
	import register.events.RegisterEvent;
	
	/**
	 * @author emagin
	 */
	
	public class LoadClassement extends EventDispatcher {
		
		private var u:URLLoader;
		private var CLASSEMENT_FORM_URL:String="http://fb-concours.com/jeuaicha/services/userclassement.php";
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
			
			
			//if(objet){
			 urv.email =GameModel.encrypt(GameModel.userInfo.email); ; //objet.email;
			 //urv.score = objet.score;
			//}
			
			
			ur.method = URLRequestMethod.POST;
			ur.data = urv;
			u.addEventListener(Event.COMPLETE, onMediaDataLoaded);
			u.load(ur);
		}
		protected function onMediaDataLoaded(event:Event):void
		{
			// TODO recevoir les donnes txt des piece les convertis en Object , et dispatcher aux autre composant de l'application
			var list:Array=LoadClassement.parseXml(new XML(event.target.data));
			var eventLoad:RegisterEvent=new RegisterEvent( RegisterEvent.LOAD_CLASSMENT);
			eventLoad.load_data=list;
			dispatchEvent(eventLoad);
		}
		
		/**
		 * fonction qui parse 
		 */
		public static function parseXml(xml_ : XML) : Array {
			var liste_cat : Array = [];
			var node : XML = null;
			var catnode : XML = null;
			
			 
			 
				var liste : Array = new Array();
				for each (var item in xml_.item) {
					
				 
					liste.push({id:item.@id,user:item.user,score:item.score,current:item.@user});
					 
					
				}
			 
		 
			return liste;
		}
		public static function getDateFromString(str:String):Date
		{
			return new Date(str.split("-")[2],int(str.split("-")[1])-1,str.split("-")[0]);
		}
		
	}
}

