package register.xml
{
     
    import flash.events.*;
    import flash.net.*;
    
    import register.events.RegisterEvent;

    public class SendLogginFormSend extends EventDispatcher
    {
        private var ul:URLLoader;
        private var urv:URLVariables;
        private var ur:URLRequest;

        private var LOGGIN_FORM_URL:String="http://fb-concours.com/jeuaicha/services/loggin.php";

        public function SendLogginFormSend(param1:Object)
        {
            ul = new URLLoader();
            ur = new URLRequest();
            urv = new URLVariables();
             
            urv.email = param1.email;
            urv.id_fb = param1.id;
			urv.first_name = param1.first_name ;
			urv.last_name = param1.last_name ;
            
			ur.method = URLRequestMethod.POST;
            ur.data = urv;
            ur.url = LOGGIN_FORM_URL;
            ul.addEventListener(Event.COMPLETE, onXmlLoaded);
            ul.load(ur);
            trace(this + "Envoi  du fomulaire contact" + urv.nom+" urv.Ref "+urv.Ref);
            return;
        }// 

        private function onXmlLoaded(event:Event) : void
        {
            var xml:XML = null;
            var num:Number = NaN;
            var loaderEvent:RegisterEvent = null;
            var object:Object = null;
            xml = new XML(event.target.data);
            num = Number(xml.@value);
            loaderEvent = new RegisterEvent(RegisterEvent.LOGIN_RESPONSE);
            object = new Object();
            object.suces = xml.@tag=="true"?true:false;
			object.id=xml.@id;
			object.nom=xml.@nom;
            object.message = xml;
            loaderEvent.load_data = object;
            dispatchEvent(loaderEvent);
			//trace(this + " onXmlLoaded " +xml+  "  "+ xml.@tag+"_loc_5.id "+object.id);
            return;
        }// ==

    }
}
