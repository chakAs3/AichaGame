package register
{
	import com.greensock.TweenLite;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import myobjects.model.GameModel;
	
	import register.events.RegisterEvent;
	import register.manager.FaceBookGraph;
	import register.xml.SendLogginFormSend;
	
	public class HomePanel extends Sprite
	{
		public var btn_register:SimpleButton ;
		public var btn_deja:SimpleButton ;
		public var btn_instructions:SimpleButton ;
		public var mc_help:HelpPanel;
		private var facebook:FaceBookGraph;
		public function HomePanel()
		{
			super();
			btn_register.addEventListener(MouseEvent.CLICK,onClickRegister);
			btn_deja.addEventListener(MouseEvent.CLICK , onClickDeja);
			btn_instructions.addEventListener(MouseEvent.CLICK , onClickInstructions);
			facebook=new FaceBookGraph();
		}
		
		protected function onClickInstructions(event:MouseEvent):void
		{
			TweenLite.to(mc_help,0.6,{alpha:1,y:0});
			
		}
		
		public function animateIn():void{
			for (var i:int = 0; i < numChildren; i++) 
			{
				if(!(getChildAt(i) is SimpleButton)){
				TweenLite.from(getChildAt(i),0.4,{y:getChildAt(i).y+10,alpha:0,delay:i*0.09});
				}
			}
			
		}
		
		protected function onClickDeja(event:MouseEvent):void
		{
			 
			if(FaceBookGraph.userInfo)
				onLogginDejaInscrit(null);
			else{
				facebook.handleLoginClick(null);	
				facebook.addEventListener("FaceBookLoggin",onLogginDejaInscrit);
			}
		}
		
		protected function onClickRegister(event:MouseEvent):void
		{
			// dispatchEvent(new RegisterEvent(RegisterEvent.CHANGE_PAGE,1));
			if(facebook.hasEventListener("FaceBookLoggin")){
				facebook.removeEventListener("FaceBookLoggin",onFaceLogginRegister);
				facebook.removeEventListener("FaceBookLoggin",onLogginDejaInscrit)
			}
			facebook.addEventListener("FaceBookLoggin",onFaceLogginRegister);
			if(!FaceBookGraph.userInfo){
				
				facebook.handleLoginClick(null);
			}else{
				dispatchEvent(new RegisterEvent(RegisterEvent.CHANGE_PAGE,1));
				//ExternalInterface.call("console.log"," RegisterPanel "+FaceBookGraph.userInfo);
			}
			
		}
		protected function onFaceLogginRegister(event:Event):void
		{
			dispatchEvent(new RegisterEvent(RegisterEvent.CHANGE_PAGE,1));
			
		}
		protected function onLogginDejaInscrit(event:Event):void
		{
			
			var sendLoggin:SendLogginFormSend=new SendLogginFormSend(GameModel.userInfo);
			sendLoggin.addEventListener(RegisterEvent.LOGIN_RESPONSE,onReponseLoggin);
			//dispatchEvent(new Event("DejaInscrit",true));
		}
		
		protected function onReponseLoggin(event:RegisterEvent):void
		{
			if(event.load_data.suces ){
				dispatchEvent(new Event("DejaInscrit",true));
			}
			
		}
	}
}