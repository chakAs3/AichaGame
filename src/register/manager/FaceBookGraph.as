package register.manager{
	import com.adobe.serialization.json.JSON;
	import com.facebook.graph.Facebook;
	import com.facebook.graph.utils.FacebookDataUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	
	import myobjects.model.GameModel;
	
	public class FaceBookGraph extends Sprite {
		
		protected static const APP_ID:String = "449473045088858";//"327201890637265";//"117700911668318"; //Place your application id here
		private var isLogged:Boolean;
		public var output:TextField;
		public static var userId:String;

		public static var userInfo:Object;
		public  function FaceBookGraph() {	
			configUI();
		}
		
		public function configUI():void {
	
			//listeners for UI
		
			//Initialize Facebook library
			trace("configUI")
			Facebook.init(APP_ID, onInit);			
		}
		
		protected function onInit(result:Object, fail:Object):void {						
			if (result) { //already logged in because of existing session
				if(output)
				output.appendText( "onInit, Logged In\n");
				//loginToggleBtn.label = "Log Out";
				ExternalInterface.call("console.log"," FLASH :onInit")
			} else {
				if(output)
				output.appendText( "onInit, Not Logged In\n");
				ExternalInterface.call("console.log"," FLASH : Not onInit"+fail)
			}
		}
		
		public function handleLoginClick(event:MouseEvent=null):void {
			if (!isLogged) {
				ExternalInterface.call("console.log","FL : sendLoggin ");
				var opts:Object =  {scope: 'publish_stream,email,user_about_me,user_birthday,user_hometown,user_location,read_stream,'};// {scope:"publish_stream, email"}//{perms:"publish_stream, email"};//
				Facebook.login(onLogin, opts);
				//Facebook.addJSEventListener('auth.sessionChange', callback);
			} else {
				Facebook.logout(onLogout);
			}
		}
		public function callback(result:Object, fail:Object):void{
			ExternalInterface.call("console.log","FL : js callback ");
		}
		protected function onLogin(result:Object, fail:Object):void {
			if (result) { //successfully logged in
				if(output)
				output.appendText("Logged In"+result+"\n");
				//userId=result.userId;
				ExternalInterface.call("console.log"," FLASH :  Logged In");
				Facebook.api("/me",onGetInfoUser);
			 
			} else {
				trace("Login Failed\n");
				ExternalInterface.call("console.log"," FLASH :  Login Failed"+fail);
			}
		}
		
		private function onGetInfoUser(result:Object, fail:Object):void
		{
			//output.appendText("onGetInfoUser"+result+"\n");
			if(result){
				ExternalInterface.call("console.log"," FLASH :  Get Info");
				userInfo=result;
				GameModel.userInfo=result;
				if(output)
				output.appendText("onGetInfoUser"+result);
				dispatchEvent(new Event("FaceBookLoggin"));
				
		    }
		     else{
				 if(output)
			     output.appendText("onGetInfoUser fail"+fail);
				 ExternalInterface.call("console.log"," FLASH :onGetInfoUser  Failed");
		    }
		}
		public function getFriends():void{
			Facebook.api("/me/friends",onGetFriendsUser);
		}
		private function onGetFriendsUser(result:Object, fail:Object):void
		{
			trace(this+" onGetFriendsUser ");
			if(output)
			output.appendText( " onGetFriendsUser \n");
			userInfo.friends=new Array(result);
			userInfo.friendsIds=new Array();
		//	GameModel.userInfo=userInfo;
			for each (var friend:Object in result) 
			{
				//output.appendText( " - name: "+friend.name+" ,id "+friend.id+"\n");
				userInfo.friendsIds.push(friend.id);
			} 
			dispatchEvent(new Event("FaceBookLoadFriends"));
		}
		public static function publishToStream(pmessage:String,publication:String,source:String="http://optimumbuzz.ma/images/application.jpg"):void {
			var attachment:Object = {message:pmessage,picture:"http://optimumbuzz.ma/images/logo.jpg",link:"http://www.facebook.com/HuaweiMobileMaroc",name:publication,caption:"Huawei Maroc",description:"plein de cadeaux à gagner !",source:source};
			Facebook.api("/me/feed",submitPostHandler,attachment,"POST");
		}
		public static function submitPostHandler(result:Object):void
		{
			
		}

		public static function inviteFriends(onUICallback:Function,invited:Array=null,toinvite:Array=null):void
		{
			var dat:Object = new Object();
			dat.message = "Participe toi aussi au jeu Aicha  ! ";
			dat.title   = "Invite tes amis";
			// filtering for non app users only
			dat.filters = ['app_non_users']; 
			//You can use these two options for diasplaying friends invitation window 'iframe' 'popup'
			if(invited && invited.length){
				dat.exclude_ids=invited;
			}
			if(toinvite){
				dat.to=toinvite;
			}
			
			Facebook.ui('apprequests', dat, onUICallback);
		}
		protected function onLogout(success:Boolean):void {			
			trace ( "Logged Out");
			 			
		}
		
	 
		
		 
	}
}