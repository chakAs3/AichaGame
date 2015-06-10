package {

	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.core.StarlingState;
	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.platformer.box2d.Baddy;
	import com.citrusengine.objects.platformer.box2d.Crate;
	import com.citrusengine.objects.platformer.box2d.Hero;
	import com.citrusengine.objects.platformer.box2d.MovingPlatform;
	import com.citrusengine.objects.platformer.box2d.Platform;
	import com.citrusengine.objects.platformer.box2d.Reward;
	import com.citrusengine.objects.platformer.box2d.Sensor;
	import com.citrusengine.physics.Box2D;
	import com.citrusengine.utils.ObjectMaker;
	import com.citrusengine.view.starlingview.AnimationSequence;
	import com.citrusengine.view.starlingview.StarlingArt;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import myobjects.AichaHero;
	import myobjects.BoxManager;
	import myobjects.HeroManager;
	import myobjects.MyMovingPlateform;
	import myobjects.PlatformBridge;
	import myobjects.ReverseSenor;
	import myobjects.SpritesHeros;
	import myobjects.enemies.FishEnemy;
	import myobjects.enemies.FlyEnemy;
	import myobjects.enemies.MonkeyEnemy;
	import myobjects.enemies.PlatformEnemy;
	import myobjects.enemies.SerpentEnemy;
	import myobjects.enemies.ToppaEnemy;
	import myobjects.model.GameModel;
	import myobjects.rewards.MyCoin;
	import myobjects.rewards.Supercoin;
	import myobjects.ui.BoradMainScreen;
	
	import org.osflash.signals.Signal;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;
	

	/**
	 * @author Aymeric
	 */
	public class ALevel extends StarlingState {
		
		public var lvlEnded:Signal;
		public var restartLevel:Signal;
		
		protected var _ce:CitrusEngine;
		protected var _level:MovieClip;
		
		protected var _hero:AichaHero;
		
		 
		
		[Embed(source="../embed/ArialFont.fnt", mimeType="application/octet-stream")]
		private var _fontConfig:Class;
		
		[Embed(source="../embed/ArialFont.png")]
		private var _fontPng:Class;
	
		[Embed(source="../embed/Loader.png")]
		private var BackgroundPng:Class;
		
		protected var _maskDuringLoading:Quad;
		protected var _percentTF:TextField;

		private var animationSequence1:AnimationSequence;

		private var animationSequence2:AnimationSequence;
		
		
		

		

		private var spritesHero:SpritesHeros;

		public var heroManager:HeroManager=new HeroManager();

		private var black:CitrusSprite;

		private var _unitTime:int;

		private var box2Manager:BoxManager;

		private var water1:CitrusSprite;

		private var water2:CitrusSprite;
		private var water3:CitrusSprite;

		private var imageLoader:Image;

		private var loaderMc:Quad;
		public var loadedLevel:Signal;
		private var loaded:Boolean;

		public function ALevel(level:MovieClip = null) {
			
			super();
			
			_ce = CitrusEngine.getInstance();
			
			_level = level;
			
			lvlEnded = new Signal();
			restartLevel = new Signal();
			loadedLevel = new Signal();
			
			// Useful for not forgetting to import object from the Level Editor
			var objectsUsed:Array = [Hero, Platform, MovingPlatform, Baddy,ToppaEnemy,Crate, FlyEnemy, Reward, Sensor, CitrusSprite ,SerpentEnemy,MonkeyEnemy,MyCoin ,Supercoin ,MyMovingPlateform,ReverseSenor 
			,FishEnemy,PlatformBridge,PlatformEnemy];
		}

		public function get unitTime():int
		{
			return _unitTime;
		}

		public function set unitTime(value:int):void
		{
			_unitTime = value;
		}

		override public function initialize():void {
			
			super.initialize();
			
			var box2d:Box2D = new Box2D("Box2D");
			//box2d.visible = true;
			add(box2d); 
			
			// hide objects loading in the background
			_maskDuringLoading = new Quad(stage.stageWidth, stage.stageHeight);
			_maskDuringLoading.color = 0xF2FAEC;
			_maskDuringLoading.x = (stage.stageWidth - _maskDuringLoading.width) / 2;
			_maskDuringLoading.y = (stage.stageHeight - _maskDuringLoading.height) / 2;
			addChild(_maskDuringLoading);
			
			
			
			  
			// create a textfield to show the loading %
			var bitmap:Bitmap = new _fontPng();
			var ftTexture:Texture = Texture.fromBitmap(bitmap);
			var ftXML:XML = XML(new _fontConfig());
			TextField.registerBitmapFont(new BitmapFont(ftTexture, ftXML));
			
			/*_percentTF = new TextField(400, 200, "", "ArialMT");
			_percentTF.fontSize = BitmapFont.NATIVE_SIZE;
			_percentTF.color = Color.WHITE;
			_percentTF.autoScale = true;
			_percentTF.x = (stage.stageWidth - _percentTF.width) / 2;
			_percentTF.y = (stage.stageHeight - _percentTF.height) / 2;
			
			addChild(_percentTF);*/
			
			
			
			
			loaderMc = new Quad(210,11,0x539A3B);
			loaderMc.x = (stage.stageWidth - loaderMc.width) / 2;
			loaderMc.y = (stage.stageHeight - loaderMc.height) / 2;
			addChild(loaderMc);
			
			imageLoader=Image.fromBitmap(new BackgroundPng()) ;
			imageLoader.x = (stage.stageWidth - imageLoader.width) / 2;
			imageLoader.y = (stage.stageHeight - imageLoader.height) / 2;
			addChild(imageLoader);
			// when the loading is completed...
			view.loadManager.onLoadComplete.addOnce(_handleLoadComplete);
			
			// create objects from our level made with Flash Pro
			ObjectMaker.FromMovieClip(_level);
			
			// the hero view come from a sprite sheet, for the baddy that was a swf
			 
			
			// les animation Sequences pour les naims 
			spritesHero=new SpritesHeros();
			// add animation loops
			StarlingArt.setLoopAnimations(["idle","run","push","normal","crouch","die"]);
			// layer black for fhimo !
			black=new CitrusSprite("maskcoin");
			black.view="levels/mask_spr.png";
			black.y=300;
			black.visible=false;
			add(black); 
			
			//
			_hero = AichaHero(getFirstObjectByType(Hero));
			
			_hero.view = spritesHero.getAnimationSequence(GameModel.KFIZO);//"PatchStarlingArt.swf";// spritesHero.animationSequence9fizo;//
			_hero.acceleration = 0.3 ;
			_hero.height=100 ;
			_hero.width=30;
			_hero.jumpHeight = 11;
			_hero.maxVelocity = 4;
			_hero.offsetY = -6;
			_hero.sprites = spritesHero ;
			_hero.hurtDuration = 600;
			_hero.killVelocity=20;
			//heroManager=new HeroManager(_hero,this,spritesHero);
			//_hero.view = animationSequence1;//new AnimationSequence(sTextureAtlas, ["walk", "duck", "idle", "jump", "hurt"], "idle");
			heroManager.hero=_hero;
			heroManager.state=this;
			heroManager.heroAnimation=spritesHero;
			heroManager.initListeners();
			// reset timer
			_ce.gameData.timeleft=0;
			
			//box2Manager=new BoxManager();
		//	box2Manager.initialize(this,_hero);
			
			// if there a backgroud water moving 
			water1=getObjectByName("water1") as CitrusSprite;
			water2=getObjectByName("water2") as CitrusSprite;
			water3=getObjectByName("water3") as CitrusSprite;
			//var water1:CitrusSprite=getObjectByName("water1");
			//if(water1)
			//
            
			view.setupCamera(_hero, new MathVector(320, 300), new Rectangle(0, 0, 13000   , 900), new MathVector(.25, .05));
	      
		}
		
		protected function _changeLevel(cEvt:ContactEvent):void {
			
			
			if (cEvt.other.GetBody().GetUserData() is Hero) {
				lvlEnded.dispatch("");
				SoundManager.getInstance().stopSound("ambiance");
				(cEvt.other.GetBody().GetUserData() as Hero).controlsEnabled=false;
			}
		}
		
		protected function _handleLoadComplete():void {
		 
			
			//removeChild(_percentTF);
			removeChild(_maskDuringLoading);
			removeChild(imageLoader);
			removeChild(loaderMc);
			
			var backArt:StarlingArt=view.getArt(black) as StarlingArt;
			backArt.content.alpha=0.6
			backArt.content.scaleX=20;
			backArt.content.scaleY=10;
			
			startTimerGame();
			SoundManager.getInstance().stopSound("ambiance");
			SoundManager.getInstance().playSound("ambiance",0.4);
			
			Starling.current.nativeStage.focus = Starling.current.nativeStage;
		}
		
		private function startTimerGame():void
		{
			unitTime = getTimer(); 
			_ce.gameData.timeleft=0 ;
			MyGameData(_ce.gameData).resetData();
			
		}
		
		override public function update(timeDelta:Number):void {
			
			super.update(timeDelta);
			
			var percent:uint = view.loadManager.bytesLoaded / view.loadManager.bytesTotal * 100;

			if (percent < 99) {
				//_percentTF.text =percent.toString() + "%";
				loaded=false;
				loaderMc.scaleX=percent/100;
				trace(this+" Starling.current.nativeStage.focus  "+Starling.current.nativeStage.focus )
				//"St:"+(Starling.current.context.driverInfo.toLowerCase().search("software") < 0 )//
			}else{
				if(!loaded){
				  loadedLevel.dispatch();	
				  //loadedLevel.removeAll();
				  loaded=true;
				  trace(this+"loadedLevel.dispatch")
				}
				if(unitTime){
				_ce.gameData.timeleft=getTimer()-unitTime;
				 
				   if(water1 && water2 && water3){// there are water back to manage 
					   if (_hero.x + stage.stageWidth > water1.x + water1.width)
						   water2.x = water1.x + water1.width;
					   
					   if (_hero.x + stage.stageWidth > water2.x + water2.width)
						   water3.x = water2.x + water2.width;
					   
					   if (_hero.x + stage.stageWidth > water3.x + water3.width)
						   water1.x = water3.x + water3.width; 
					   
					   water1.x-=3;
					   water2.x-=3;
					   water3.x-=3;
				   }
				}
			}
		}

		override public function destroy():void {
			
			trace(this+"  destroy  ")
			TextField.unregisterBitmapFont("ArialMT");
			if(spritesHero)
			spritesHero.destroy() 
	
			super.destroy();
		}
	}
}
