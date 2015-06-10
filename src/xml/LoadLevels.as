package xml
{

    import flash.events.*;
    import flash.net.*;
    
    import myobjects.model.GameModel;
    import myobjects.model.vo.LevelScore;
    
    import xml.events.LoadEvent;

    public class LoadLevels extends EventDispatcher
    {
        public var URL_GET:String="http://fb-concours.com/jeuaicha/services/userlevels.php";//http://fb-concours.com/jeuaicha/
        private var ul:URLLoader;
        private var urv:URLVariables;
        private var ur:URLRequest;
        private var u:URLLoader;

        public function LoadLevels()
        {
			var ur:URLRequest = new URLRequest();
			var urv:URLVariables= new URLVariables();
			
			
			
			urv.email = GameModel.encrypt( GameModel.userInfo.email );
			u= new URLLoader();
			ur.method = URLRequestMethod.POST;
			ur.data = urv;
			
			
			ur.url = URL_GET;
			u.addEventListener(Event.COMPLETE, onXmlLoaded);
			u.load(ur);
            return;
        }//  

        private function onXmlLoaded(event:Event) : void
        {
			trace(" event.target.data:  "+event.target.data);
			var list:Array=LoadLevels.parseXml(new XML(event.target.data));
			var eventLoad:LoadEvent=new LoadEvent(LoadEvent.LOAD_LEVELS);
			eventLoad.load_data=list;
			dispatchEvent(eventLoad);
            return;
        }// 
		
		/**
		 * fonction qui parse 
		 */
		public static function parseXml(xml_ : XML) : Array {
			var liste : Array = [];
			var node : XML = null;
			var catnode : XML = null;
			
			var level:LevelScore;
			trace("---"+xml_);
			for each (node in xml_.level ) {
				
                level=new LevelScore()
				level.setFromXml(node);	
				liste.push(level);
				
			}
			
			return liste;
		}

    }
}
