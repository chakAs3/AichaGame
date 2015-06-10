package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class MainLoader extends Sprite
	{
		private var path:String="register.swf";
		private var loader:Loader;
		
		public var mc_loader:MovieClip;
		public var btn_loader:SimpleButton;
		
		public function MainLoader()
		{
			super();
			//(mc_preload.preload as EPreloader).setPourcent(0);*/
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			init();
		}
		private function init(e:Event=null):void
		{
			// stage.quality = StageQuality.MEDIUM;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			path=loaderInfo.parameters.path || path;
			
			 
			// onGoLoadGame(null);
			mc_loader.visible=false;
			mc_loader.alpha=0;
			mc_loader.y=0;
			mc_loader.mc_progress.scaleX=0.001;
			//loadSWF();
			btn_loader.addEventListener(MouseEvent.CLICK,onGoLoadGame);
			costumeContextMenu();
			//onGoLoadGame(null);
		}
		
		public function loadIntro():void{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoading);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			loader.load(new URLRequest("register.swf"));
			
		}
		
		private function costumeContextMenu():void
		{
			var my_menu:ContextMenu = new ContextMenu();
			my_menu.builtInItems.forwardAndBack = false;
			my_menu.builtInItems.loop = false;
			my_menu.builtInItems.play = false;
			my_menu.builtInItems.print = false;
			my_menu.builtInItems.quality = false;
			my_menu.builtInItems.rewind = false;
			my_menu.builtInItems.save = false;
			my_menu.builtInItems.zoom = false;
			
			
			var my_notice = new ContextMenuItem("Marshmallow Digital");
			var my_email = new ContextMenuItem("javachakir@gmail.com");
			var my_copyright = new ContextMenuItem("Aicha Copyright - 2012");
			
			my_menu.hideBuiltInItems();
			my_menu.customItems.push(my_notice, my_copyright);
			
			contextMenu = my_menu;
			
		}		
		
		
		protected function onGoLoadGame(event:Event):void
		{
			//GlobalModel.infoUser=FaceBookGraph.userInfo;
			mc_loader.visible=true; 
			TweenLite.to(mc_loader,1,{y:43,alpha:1,delay:1,ease:Bounce.easeOut,onComplete:function(){ loadIntro();}});
			btn_loader.visible=false;
			
		}
		 
		
		private function onLoaded(event : Event) : void {
			 
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoading);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
				
			    addGameLoaded();
			 
		}
		
		public function addGameLoaded():void{
			 
				removeChildAt(0);
				removeChild(mc_loader);
				addChild(loader.content);
				removeChild(btn_loader); 
		}
		
		private function onLoading(event : ProgressEvent) : void {
			trace(this+" onLoading "+event.bytesLoaded);
			
			//mc_loader.txt_label.text=Math.floor((event.bytesLoaded/event.bytesTotal)*100) + " %";
			mc_loader.mc_progress.scaleX=(event.bytesLoaded/event.bytesTotal);
		}
	}
}