package myobjects
{
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.core.StarlingState;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.view.starlingview.AnimationSequence;
	import com.citrusengine.view.starlingview.StarlingArt;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import myobjects.model.GameModel;
	
	import starling.events.KeyboardEvent;
	
	//import starling.events.KeyboardEvent;

	public class HeroManager
	{
		public var currentHero:int=GameModel.KFIZO;
		private var _hero:AichaHero;
		private var _state:StarlingState;
		private var _heroAnimation:SpritesHeros;

		private var enabledTransformation:Boolean=true;
		private var _selectMenu:*;

		private var controlsTimer:int;
//		private var connection:DirectLanConnection;
		private var _ce:CitrusEngine;
		private var timerOut:uint;
		public function HeroManager(hero:AichaHero=null,state:StarlingState=null,heroAnimation:SpritesHeros=null)
		{
			this.hero=hero;
			this.state=state;
			this.heroAnimation=heroAnimation
			
			//state.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDownHanlder_)
				_ce=CitrusEngine.getInstance();
		}
		public function initListeners():void {
			state.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyUpHanlder) ;
		}

		public function get heroAnimation():SpritesHeros
		{
			return _heroAnimation;
		}

		public function set heroAnimation(value:SpritesHeros):void
		{
			_heroAnimation = value;
		}

		public function get state():StarlingState
		{
			return _state;
		}

		public function set state(value:StarlingState):void
		{
			_state = value;
		}

		public function get hero():AichaHero
		{
			return _hero;
		}

		public function set hero(value:AichaHero):void
		{
			_hero = value;
		}

		public function get selectMenu():*
		{
			return _selectMenu;
		}

		public function set selectMenu(value:*):void
		{
			_selectMenu = value;
			if(_selectMenu){
				_selectMenu.addEventListener(GameEvent.SHOW_MENU,onShowMenu);
				_selectMenu.addEventListener(GameEvent.SELECT_HERO,onSelectPersonnage);
				//initConnectioP2P();
			}
		}
		
		private function onShowMenu(event:GameEvent):void{
			trace(this+" onShowMenu "+event.data+" hero.x: "+hero.x+" getArt: "+state.view.getArt(hero));
			
			if(!state.view.getArt(hero)) return ;
			
			if( currentHero==GameModel.KSILO && hero.animation!="idle"){
				trace(" KeyboardEvent.KEY_UP  Keyboard.C") ;
				_selectMenu.visible=false;
			//	_ce.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP,  false, false, 0, Keyboard.C, 0));
				return ;
			}
			_selectMenu.visible=true;
			var point:Point=	StarlingArt(state.view.getArt(hero)).localToGlobal(new Point(0,0));
			selectMenu.x=Math.max(point.x);
			selectMenu.y=Math.max(100,point.y);
			 
			if(controlsTimer) clearTimeout(controlsTimer);
			hero.controlsEnabled=false;
			SoundManager.getInstance().playSound("menu_design",1,1);
			 
		}
		
        private function onSelectPersonnage(event:GameEvent):void{
			trace(this+" onSelectPersonnage "+event.data);
			
			if( hero.animation == "idle" || hero.animation == "walk" ){
				currentHero=int(event.data);
				setView(currentHero);
			}
			//setView(currentHero);
			
		}
		private function onKeyUpHanlder_(event:KeyboardEvent):void
		{
			 
			if(hero.animation=="idle"){
				
				switch(event.keyCode)
				{
					case Keyboard.CONTROL:
					{
						selectMenu.show(false);
						break;
					}
					 
						
					default:
					{
						break;
					}
				}
				
				
			}
			
		}
		
		private function onKeyDownHanlder_(event:KeyboardEvent):void
		{
			
			if(hero.animation=="idle"){
				
				switch(event.keyCode)
				{
					case Keyboard.CONTROL:
					{
						selectMenu.show(true);
						break;
					}
						
					default:
					{
						break;
					}
				}
			}
			
		}
		
		private function onKeyUpHanlder(event:KeyboardEvent):void
		{
			if(!enabledTransformation) return ;
			enabledTransformation=false;
			setTimeout(function (){enabledTransformation=true },500);
			if(hero.animation=="idle"){
				
				switch(event.keyCode)
				{
					case Keyboard.NUMBER_1:
					{
						setView(0);
						break;
					}
					case Keyboard.NUMBER_2:
					{
						setView(3);
						break;
					}
					case Keyboard.NUMBER_3:
					{
						setView(2);
						break;
					}
					case Keyboard.NUMBER_4:
					{
						setView(4);
						break;
					}
					case Keyboard.NUMBER_5:
					{
						setView(5);
						break;
					}
					case Keyboard.NUMBER_6:
					{
						setView(6);
						break;
					}
					case Keyboard.NUMBER_7:
					{
						setView(1);
						break;
					}
						
					default:
					{
						break;
					}
				}
				 
				
			}
			
		}
		public function setView(index:int):void{
			
			 
		   if(controlsTimer){ hero.controlsEnabled = true;  clearTimeout(controlsTimer); };
		   hero.controlsEnabled = false;
			controlsTimer=setTimeout(function(){ hero.controlsEnabled = true;  },600);
			
			if(index==hero.currentHero || index > 7 ) return ; // no change
			
			if(timerOut) clearTimeout(timerOut);
			
			hero.view="";   // disappear hero before
			SoundManager.getInstance().playSound("transform",1,1);
			var transSpark:CitrusSprite=new CitrusSprite("transformSpark",{view:heroAnimation.getAnimationSequenceTransHero()})
			 
			transSpark.x=hero.x-160;
			transSpark.y=hero.y-150;
			if(state.getObjectByName("transformSpark")){ 
				state.remove(state.getObjectByName("transformSpark")) ;
			}
			state.add(transSpark);
			timerOut = setTimeout(function (_index:int):void{
				var ha:AnimationSequence=heroAnimation.getAnimationSequence(_index);
				if(ha)
				hero.view=ha//?ha:"";
				//state.remove(state.getObjectByName("transformSpark")) ;
				if(state.getObjectByName("transformSpark")){
					state.remove(state.getObjectByName("transformSpark")) 
				}
				 
			},400,index);
			hero.currentHero=index;
		}
		
		
	/*	public function initConnectioP2P():void{
			
			if((connection && !connection.isConnected) || connection == null)
			{
				//if(codeInput.text == "") return;
				
				connection = new DirectLanConnection();
				connection.onConnect = handleConnectToService;
				connection.onDataRecieve = handleGetObject
				connection.connect("aichagame");
				trace(" connection  ");
			}
			else
			{
				connection.close();
				//connectBtn.label = "Connect";
				trace(" handleConnect  ");
			}
		}
		protected function handleConnectToService(user:Object):void
		{
			
			trace(" handleConnectToService  ");
			
		}*/
		
		/*protected function handleGetObject(user:Object):void
		{
			// nothing here for now, meaybe we can add a speedometer for the car or a gas gauge?
			//{type:"rotation", angle:Math.round(aX * 100)} 
			trace("\n handleGetObject type  "+user.type);
			 
			
			switch(user.type) {
				case "back_release":
                    _ce.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP,  true, false, 0, Keyboard.LEFT, 0));
					break;
				case "forward_release":
					_ce.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP,  true, false, 0, Keyboard.RIGHT, 0));
					break;
				case "back_press":
					_ce.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,  false, false, 0, Keyboard.LEFT, 0));
					break; 
				case "forward_press":
					_ce.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,  false, false, 0, Keyboard.RIGHT, 0));
					break;
				case "power_press":
					_ce.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,  false, false, 0, Keyboard.SPACE, 0));
					break;
				case "change_press":
					_ce.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN,  false, false, 0, Keyboard.C, 0));
					break;
				case "power_release":
					_ce.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP,  false, false, 0, Keyboard.SPACE, 0));
					break;
				case "change_release":
					_ce.stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP,  false, false, 0, Keyboard.C, 0));
					break;
				
				case "rotation":
				 
					break;
				
			}
		}*/
	}
}