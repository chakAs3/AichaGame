package register.xml
{
   
    import flash.events.*;
    import flash.net.*;
    
    import register.events.RegisterEvent;

    public class RegisterFormSend extends EventDispatcher
    {
        private var ul:URLLoader;
        private var urv:URLVariables;
        private var ur:URLRequest;

        private var CONTACT_FORM_URL:String="http://fb-concours.com/jeuaicha/services/register.php";

        public function RegisterFormSend(param1:Object)
        {
            ul = new URLLoader();
            ur = new URLRequest();
            urv = new URLVariables();
			urv.id_fb=param1.userId;
			 
            urv.nom= param1.nom;
			urv.prenom= param1.prenom
            urv.email = param1.email;
            urv.tel = param1.tel;
            urv.ville = param1.ville;
			urv.sex = param1.sex;
			urv.team=param1.team;
			urv.cin=param1.cin;
			urv.locale=param1.locale;
			urv.datenaissance = param1.date;
			
			ur.method = URLRequestMethod.POST;
            ur.data = urv;
            ur.url = CONTACT_FORM_URL;
            ul.addEventListener(Event.COMPLETE, onXmlLoaded);
            ul.load(ur);
            trace(this + "Envoi  du fomulaire contact" + urv.nom+" urv.Ref "+urv.email+"  "+param1.ville);
             
        } 

        private function onXmlLoaded(event:Event) : void
        {
            var xml:XML = null;
            var num:Number = NaN;
            var loadEvent:RegisterEvent = null;
            var object:Object = null;
            xml = new XML(event.target.data);
            num = Number(xml.@value);
            loadEvent = new RegisterEvent( RegisterEvent.LOAD_REGISTER);
            object = new Object();
            object.suces =xml.@tag=="true"?true:false;//Boolean( xml.@tag=="true");
            object.message = xml;
            loadEvent.load_data = object;
            dispatchEvent(loadEvent);
            
        } 

    }
}
