package register
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import myobjects.model.GameModel;
	
	import register.events.RegisterEvent;
	import register.xml.LoadListe;
	
	import xml.events.LoadEvent;
	
	
	public class MainPanel extends Sprite
	{
		public var currentPanel:Sprite;
		private var pages:Array;
		
		
		public function MainPanel()
		{
			super();
			addEventListener(RegisterEvent.CHANGE_PAGE,onChangePage);
			pages=[new HomePanel(),new RegisterPanel()];
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			addEventListener("RegisterDone",onRegisterDone);
			addEventListener("DejaInscrit",onRegisterDone);
			setPanel(pages[0]);
			loadData();
			
		}
		
		protected function onRegisterDone(event:Event):void
		{
			dispatchEvent(new Event("LoadGame",true));
			if(currentPanel){
				TweenLite.to(currentPanel,0.5,{x:-currentPanel.width-40,alpha:0});
			}
		}
		
		protected function onChangePage(event:RegisterEvent):void
		{
			setPanel(pages[int(event.load_data)])
			
		}
		public function setPanel(panel:Sprite):void
		{
			if(currentPanel){
				TweenLite.to(currentPanel,0.5,{x:-currentPanel.width-40});
			}
			addChild(panel);
			panel.x=stage.stageWidth+40;
			panel.y=0;
			TweenLite.to(panel,0.5,{x:0});
			currentPanel=panel;
			if(currentPanel is HomePanel)
			HomePanel(currentPanel).animateIn();
			if(currentPanel is RegisterPanel){
				(currentPanel as RegisterPanel).setInfoFromFaceObjet(GameModel.userInfo);
			}
		}
		
		public function loadData():void{
			var loadVille:LoadListe=new LoadListe();
			loadVille.load("http://fb-concours.com/jeuaicha/services/villes.php");
			loadVille.addEventListener(LoadEvent.LOAD_VILLE,onLoadVilles);
			 
		}
		protected function onLoadVilles(event:LoadEvent):void
		{
			CModel.villeList=event.load_data as Array;
			( pages[1] as RegisterPanel ).villeCombo.setData(CModel.villeList);
		} 
	}
}