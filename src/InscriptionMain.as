package
{
    import com.greensock.TweenLite;
    import com.greensock.easing.Bounce;
    
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.media.SoundMixer;
    import flash.net.URLRequest;
    import flash.text.TextField;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.utils.setTimeout;
    
    import register.MainPanel;
	
	public class InscriptionMain extends Sprite
	{
		private var path:String="Main.swf";
		private var loader:Loader;
 
		public var mc_loader:MovieClip;
		public var mainPanel:MainPanel ;
		
		public var bg_effect:MovieClip
		private var introLoaded:Boolean;
		private var intro:DisplayObject;
		private var endIntro:Boolean;
		private var gameLoaded:Boolean;
		public function InscriptionMain()
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
			 
			 mainPanel=new MainPanel();
			 addChild(mainPanel);
			 
			 
			 addEventListener("LoadGame" , onGoLoadGame );
			 // onGoLoadGame(null);
			 mc_loader.visible=false;
			 mc_loader.alpha=0;
			 mc_loader.y=0;
			 mc_loader.mc_progress.scaleX=0.001;
			//loadSWF();
			 
			 costumeContextMenu();
			 introLoaded=false ;
		}
		
		public function loadIntro():void{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoading);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			loader.load(new URLRequest("intro.swf"));
			
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
		    TweenLite.to(mc_loader,1,{y:153,alpha:1,delay:1,ease:Bounce.easeOut,onComplete:function(){ loadIntro();}});
			 
			 
		}
		public function loadSWF():void{
			//getChildAt(1).visible=false;
			mc_loader.mc_loader.visible=false;
			addChild(mc_loader);
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoading);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
			loader.load(new URLRequest(path));
			
		}
		
		private function onLoaded(event : Event) : void {
			if(!introLoaded){
				intro=loader.content ;
				(intro as MovieClip).gotoAndPlay(1);
				addChild(intro);
				setTimeout(function(){ endIntro=true 
				    if(gameLoaded)
						addGameLoaded();
    				 
				},26000);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoading);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
				setTimeout(loadSWF,4000);
				introLoaded=true;
				mc_loader.y=323;
				
			}else{
			 loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoading);
			 loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoaded);
			 gameLoaded=true;
			 if(endIntro)
			 addGameLoaded();
			}
		}
		
		public function addGameLoaded():void{
			gameLoaded=false;
			SoundMixer.stopAll();
			setTimeout(function(){
				(intro as MovieClip).stop();
				intro.loaderInfo.loader.unload(); 
				removeChildAt(0);
				removeChild(mc_loader);
				removeChild(mainPanel);
				removeChild(intro);
				
			    //loader.unload();
				addChild(loader.content);
			 
			},1000);
		}
		
		private function onLoading(event : ProgressEvent) : void {
			trace(this+" onLoading "+event.bytesLoaded);
		
			 //mc_loader.txt_label.text=Math.floor((event.bytesLoaded/event.bytesTotal)*100) + " %";
			mc_loader.mc_progress.scaleX=(event.bytesLoaded/event.bytesTotal);
		}
	}
}