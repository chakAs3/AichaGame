package xml.events
{
    import flash.events.*;

    public class LoadEvent extends Event
    {
        public var load_data:Object;
        public static const LOAD_VIDEO:String = "LoadEvent.LOAD_VIDEO";
        public static const COMMENT_RESPONSE_ADD:String = "LoadEvent.COMMENT_RESPONSE_ADD";
        public static const LOAD_VIDEOS_GALERY:String = "LoadEvent.LOAD_VIDEOS_GALERY";
        public static const LOAD_COMMENTS_VIDEO:String = "LoadEvent.LOAD_COMMENTS_VIDEO";
        public static const VALIDATE_STEP1:String = "LoadEvent.VALIDATE_STEP1";
        public static const LOAD_EVENTS:String = "LoadEvent.LOAD_EVENTS";
        public static const LOAD_CLASSMENT:String = "LoadEvent.LOAD_TEAMS";       
      
        public static const LOAD_LANG:String = "LoadEvent.LOAD_LANG";
        public static const VIDEO_RESPONSE_ADD:String = "LoadEvent.VIDEO_RESPONSE_ADD";
        public static const LOAD_CONFIG:String = "LoadEvent.LOAD_CONFIG";
        public static const RESPONSE_NEWSLETTERS:String = "LoadEvent.RESPONSE_NEWSLETTERS";
        public static const VALIDATE_STEP2:String = "LoadEvent.VALIDATE_STEP2";
        public static const VOTE_RESPONSE_ADD:String = "LoadEvent.VOTE_RESPONSE_ADD";
        public static var LOAD_CONTACT:String;
        public static var LOAD_REGISTER:String = "LoadEvent.LOAD_REGISTER";;
        public static var RESULTAS_RESPONSE:String= "LoadEvent.RESULTAS_RESPONSE";;;
        public static var LOAD_LEVELS:String= "LoadEvent.LOAD_LEVELS";
        public static const LOAD_VILLE:String="LoadEvent.LOAD_VILLE";

        public function LoadEvent(param1:String) : void
        {
            super(param1, true);
            return;
        }// end function

    }
}
