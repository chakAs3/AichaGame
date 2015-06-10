package {

	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.core.IState;
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.utils.LevelManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import myobjects.Utils;
	import myobjects.rewards.MyCoin;
	import myobjects.ui.BoradMainScreen;
	import myobjects.ui.LevelClearScreen;
	import myobjects.ui.LevelsScreen;
	
	import register.classement.ClassementPanel;
	
	[SWF(backgroundColor="#2CBAEA", frameRate="35", width="800", height="600")]

	/**
	 * @author Chakir
	 */
	public class Main extends CitrusEngine {

		private var txtLabel:TextField;
		[Embed(source="../embed/interface/Interfaces.swf" )]
		private var Assets:Class;
		
		[Embed(source="../embed/interface/interfaceMain.swf", symbol="MainScreen")] 
		public var mainScreen:Class;
		
		[Embed(source="../embed/interface/interfaceMain.swf", symbol="LevelClear")] 
		public var levelClear:Class;
		
		[Embed(source="../embed/interface/interfaceMain.swf", symbol="LevelsScreen")] 
		public var levelsScreen:Class;
		
		[Embed(source="../embed/interface/interfaceMain.swf", symbol="ClassementPanelScreen")] 
		public var classementPanel:Class;
		
		[Embed(source="../embed/interface/interfaceMain.swf", symbol="ClassemenItemView")] 
		public var classementItem:Class;
		
		private var selectMenu:*;
		private var mainBoard:BoradMainScreen;

		private var spriteRoot:Sprite;

		private var levelIndex:int=1;
		
		 
		public function Main() {
			
			
			
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			 
			//(levelManager.currentLevel as ALevel).heroManager.selectMenu=selectMenu;
			// heroManager.selectMenu=selectMenu ;
		}
		
		protected function onAdded(event:Event):void
		{
			
			removeEventListener(Event.ADDED_TO_STAGE,onAdded);
			
			levelIndex=int( root.loaderInfo.parameters.level  ) || levelIndex ;
			
			setUpStarling(false);
			
			gameData = new MyGameData();
			
			levelManager = new LevelManager(ALevel);
			levelManager.onLevelChanged.add(_onLevelChanged);
			levelManager.levels = gameData.levels;
			//levelManager.gotoLevel(levelIndex);  
			   
			
			txtLabel=new TextField();
			txtLabel.textColor=0xFF0000;    
			txtLabel.y=300;
			
			
			//txtLabel.text="Helloooooooooooo";
			//addChild(txtLabel);
			spriteRoot=new Sprite();
			addChild(spriteRoot);
			
			addMenuInterface();
			addSounds();
			addEventsData();
			addLevelsPanel();
			
		}
		
		private function _onLevelChanged(lvl:ALevel):void {
			
			//trace("_onLevelChanged  stage.numChildren :"+stage.getChildAt(0),stage.getChildAt(1))
			mainBoard.view.visible=false;
			if((state as ALevel) && (state as ALevel).root ){ trace(" scene invisible ");(state as ALevel).root.visible=false; }
			state = lvl;
  
			lvl.lvlEnded.add(_endLevel);
			lvl.restartLevel.add(_restartLevel); 
			lvl.loadedLevel.add(_loadedLevel);
			lvl.heroManager.selectMenu=selectMenu;
			if(spriteRoot)
			addChild(spriteRoot);
			
			//lvl.visible=false;
			
			//txtLabel.text="_onLevelChanged "+state;
		}
		
		private function _loadedLevel():void
		{
			mainBoard.view.visible=true;
			if((state as ALevel) && (state as ALevel).root ){ trace(" scene invisible ");(state as ALevel).root.visible=true; }
			
			//ALevel(state).visible=true;
			trace(this+"_loadedLevel ");
			
		}
		
		private function _endLevel(arg:Object):void{
			trace(this+" _endLevel addLevelClealPanel:");
			addLevelClealPanel(arg);
		}

		private function _nextLevel():void {
			 

			mainBoard.view.visible=false;
			levelManager.nextLevel();
			MyGameData(gameData).resetData();//=false;
			//MyGameData(gameData).addLettre("reset");
		}

		private function _restartLevel():void {


			mainBoard.view.visible=false;
			state = levelManager.currentLevel as IState;
			playing=true;
			MyGameData(gameData).resetData() 
			//MyGameData(gameData).addLettre("reset");
			SoundManager.getInstance().stopSound("ambiance")	
		}
		
	
		private function addEventsData():void
		{
			 gameData.dataChanged.add(myFunctionDataChanged);//
			
		}
		
		protected function myFunctionDataChanged(typeData:String,value:*):void {
			

			// update main Board View 
			if(!mainBoard ) return;
			switch(typeData)
			{
				case "lives":
				{
					mainBoard.setLife(value);
					break;
				}
				case "score":
				{
					mainBoard.setScore(value+"");
					break;
				}
				case "fruit":
				{
					mainBoard.setFruit(value+"");
					break;
				}
					
				case "timeleft":
				{
					//trace(this+" timeleft "+value )
					mainBoard.setTime("Temps "+Utils.getTimeFormat(value)+"");
					break;
				}	
				case "addletter":
				{
					trace(this+" addletter "+value )
					mainBoard.getLettre(value+"");
					break;
				}
				default:
				{
					break;
				}
			}
			
		}

		/**
		 * create the ui game menu
		 */
		private function addMenuInterface():void
		{		
			var assets:MovieClip=new Assets()  
			var board:*=new mainScreen() ;//as MovieClip;
			
			mainBoard=new BoradMainScreen(board);
			mainBoard.signal.add(_menuCommand);
			selectMenu=assets.getChildAt(0);
			
			spriteRoot.addChild(selectMenu);
			spriteRoot.addChild(board);
			mainBoard.view.visible=false;

			mainBoard.setListeners();
		 
			addChild(spriteRoot);
		}
		
		private function _menuCommand(command:String):void
		{
			switch(command)
			{
				case "reprendre": // resume
				{
				    (state as ALevel).unitTime = getTimer() - gameData.timeleft ;
					playing = true;	
					break;
				}
				case "replay": // replay
				{
					playing = true ; 
					setTimeout(_restartLevel,500);
					break; 
				}
				case "home": // go home screen
				{
				 
					addLevelsPanel();
					break;
				}
				case "pause": // pause the game
				{
					playing=false;
					break;
				}
				case "classement":  // go to leaderboard screen
				{
					addClassementPanel();
					break;
				}	
				 
				default:
				{
					break;
				}
			}
			return ;
		}

		/**
		 * add all sounds for the game
		 */
		public function addSounds():void{
		
			var sm:SoundManager=SoundManager.getInstance();
			    sm.addSound("walk","levels/sfx/walk_sfx.mp3");
			    sm.addSound("ambiance","levels/sfx/aicha_music.mp3");
				sm.addSound("eat","levels/sfx/bonus_sfx.mp3");
				sm.addSound("jump","levels/sfx/jump_sfx.mp3");
				sm.addSound("supercoin","levels/sfx/supercoin_sfx.mp3");
				sm.addSound("menu_design","levels/sfx/menu_design_sfx.mp3");
				sm.addSound("transform","levels/sfx/transform_sfx.mp3");
				sm.addSound("levels","levels/sfx/aichamenu.mp3");
				sm.addSound("die","levels/sfx/die.mp3");
				sm.addSound("hurt","levels/sfx/hurt.mp3"); 
	    }
		
		
		public function addLevelClealPanel(arg:Object):void{
			var view:* = new levelClear(); //as MovieClip;
			
			var leveClearScreen:LevelClearScreen=new LevelClearScreen(view);
			leveClearScreen.restartSignal.add(_restartLevel); 
			leveClearScreen.nextSignal.add(_nextLevel);
			leveClearScreen.signal.add(_menuCommand);
			// calcul scores
			var lenghCoins:Vector.<CitrusObject>=state.getObjectsByType(MyCoin);//.length;
			MyGameData(gameData).allFruits = !fruitInState(lenghCoins); //((lenghCoins+4-MyGameData(gameData).levels.length-MyGameData(gameData).superCoinTaked) <= 0 )//|| state.getObjectsByType(MyCoin).length );
			MyGameData(gameData).score_time = int(Math.max(0,MyGameData.MAX_TIME-gameData.timeleft) * MyGameData.SCORE_TIME /1000)
			MyGameData(gameData).score+= MyGameData(gameData).score_time;
			MyGameData(gameData).level = (levelManager.currentIndex+1);//levels.indexOf(levelManager.currentLevel);
			// ***************************************************************** //
			leveClearScreen.setData(MyGameData(gameData),arg);
			leveClearScreen.name="levelClear";
			if(spriteRoot && spriteRoot.getChildByName("levelClear")){
				spriteRoot.removeChild(spriteRoot.getChildByName("levelClear"));
			}
			MyGameData(gameData).resetData();
			spriteRoot.addChild(leveClearScreen);//
			SoundManager.getInstance().stopSound("ambiance");
			
			if((state as ALevel) && (state as ALevel).root ){ trace(" scene invisible ");(state as ALevel).root.visible=false; }
			
		}
		public function fruitInState(vec:Vector.<CitrusObject>):Boolean
		{
			for each (var i:CitrusObject in vec) 
			{
				var veiw:String=(i as MyCoin).view;
				trace(this+"fruitInState "+i+" = "+veiw);
				if(veiw == "levels/common/Peche.swf" || veiw =="levels/common/Poire.swf" || veiw =="levels/common/Pomme.swf" ){
					return true ;
				}
			}
			return false
		}

		/**
		 * add levels Screen to the main Screen
		 */
		public function addLevelsPanel():void{
			var view:* = new levelsScreen(); //as MovieClip;
			var levesScreen:LevelsScreen=new LevelsScreen(view);
			//levesScreen.startSignal.add(_restartLevel); //
			levesScreen.startSignal.add(_menuCommand);
			levesScreen.loadData();
			//levesScreen.nextSignal.add(_nextLevel); //
			SoundManager.getInstance().stopSound("ambiance");
			SoundManager.getInstance().playSound("levels");
			spriteRoot.addChild(levesScreen);
			if((state as ALevel) && (state as ALevel).root ){ trace(" scene invisible ");(state as ALevel).root.visible=false; }
			
		}
		/**
		 * add Leaderboad  Screen to the main Screen
		 */
		
		public function addClassementPanel():void{

			var view:* = new classementPanel(); //as MovieClip;
			var classementScreen:ClassementPanel=new ClassementPanel(view);
			classementScreen.classItem=classementItem;
			//levesScreen.startSignal.add(_restartLevel); //
			classementScreen.init();
			//levesScreen.nextSignal.add(_nextLevel); //
			spriteRoot.addChild(classementScreen);
		}
	
  }
}
