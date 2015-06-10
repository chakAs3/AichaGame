package xml
{
	
	/**
	 * ...
	 * @author ©haki®
	 */
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.*;
	
	import myobjects.model.GameModel;
	
	import xml.events.LoadEvent;

	public class SendScore extends EventDispatcher
	{
		private var ul:URLLoader;
		private var ur:URLRequest;
		private var urv:URLVariables;	
		public var SCORE_URL:String="http://fb-concours.com/jeuaicha/services/score.php";
		public function SendScore(objet:Object) 
		{
			ul = new URLLoader();
			ur = new URLRequest();
			urv= new URLVariables();
			
			 
			urv.email =  GameModel.encrypt(objet.email+"");
			urv.level =  objet.level 
			urv.score = GameModel.encrypt(objet.score+"");
			//urv.raja = objet.raja;
			urv.starfruit = objet.star_fruit ; 
			urv.starsuper = objet.star_super ;
			urv.starletters = objet.star_letters ;
			urv.raja = GameModel.encrypt(objet.raja);
			urv.duration = objet.duration ;
			 
			ur.method = URLRequestMethod.POST;
			ur.data = urv;
			
			
			ur.url =SCORE_URL ;
			
			trace(this+"urv.email "+urv.email+" urv.level "+urv.level+" urv.score "+urv.score+" objet.star_fruit "+objet.star_fruit+" urv.star_super "+urv.starsuper+ " urv.star_letters  "+urv.starletters)
			
			ul.addEventListener(Event.COMPLETE, onXmlLoaded);
			ul.load(ur);
			 
		}
		
		private function onXmlLoaded(e:Event):void 
		{
			trace(e.target.data);
			var xml_:XML = new XML(e.target.data);
			var value:Number=Number(xml_.@value);
			
			var event:LoadEvent=new LoadEvent(LoadEvent.RESULTAS_RESPONSE);
			
			var object:Object=new Object();
			object.suces=value;
			object.message=xml_;
			event.load_data=object;
			dispatchEvent(event);
		}
		
	}
	
}