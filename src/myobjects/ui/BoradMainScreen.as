package myobjects.ui
{
	import com.citrusengine.core.SoundManager;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import myobjects.GameEvent;
	
	import org.osflash.signals.Signal;
	
	import register.HelpPanel;
	
	public class BoradMainScreen extends MovieClip
	{
		public var view:*;
		
		
		public var txt_life:TextField;
		public var txt_score:TextField;
		public var txt_time:TextField; 
		public var txt_bonus:TextField;
		public var mc_lives:MovieClip;
		public var mc_aicha:MovieClip;
		
		
		private var btn_pause:SimpleButton;
		private var btn_sound:SimpleButton;
		private var btn_help:SimpleButton;
		
		public var signal:Signal
		private var soundMute:Boolean;
		private var isPaused:Boolean;
		
		private var mc_help:Object;
		private var mc_popup_help:HelpPanel;
		private var mc_popup:MovieClip;
		
		
		public function BoradMainScreen(view:*)
		{
			super();
			this.view = view;
		 
			txt_score = view.getChildByName("txt_score");
			txt_time = view.getChildByName("txt_time");
			txt_bonus = view.getChildByName("txt_bonus");
			mc_lives = view.getChildByName("mc_lives");
			mc_aicha = view.getChildByName("mc_aicha");
			mc_popup = view.getChildByName("mc_pause");
			mc_help = view.getChildByName("mc_help");
			
			
			// buttons 
			btn_pause = view.getChildByName("btn_pause");
			btn_sound = view.getChildByName("btn_sound");
			btn_help = view.getChildByName("btn_help");
			
			txt_time.autoSize="left";
			txt_time.x+=50;
			
			signal=new Signal();
			initLettres();
			initial() ;
			
			mc_popup_help=new HelpPanel(mc_help);
			//addChild(mc_popup_help);
			TweenLite.to(mc_popup,0.0,{y:-700});
			TweenLite.to(mc_help,0.0,{alpha:0,y:700});
			//setListeners();
			
			trace(this+"  "+view.getChildByName("mc_lives"));
		}
		public function initLettres():void{
			MovieClip(mc_aicha.mc_a1.getChildAt(1)).visible= false;
			MovieClip(mc_aicha.mc_a2.getChildAt(1)).visible= false;
			MovieClip(mc_aicha.mc_i.getChildAt(1)).visible= false;
			MovieClip(mc_aicha.mc_c.getChildAt(1)).visible= false;
			MovieClip(mc_aicha.mc_h.getChildAt(1)).visible= false
			//trace(this+" mc_aicha.mc_a1 "+ mc_aicha.mc_a1);
			trace(this+" mc_aicha.mc_a1 "+ mc_aicha.mc_a1.getChildAt(1));
		}
		
		public function setListeners():void
		{
			btn_pause.addEventListener(MouseEvent.CLICK ,onClickPause,false,0,true );
			btn_sound.addEventListener(MouseEvent.CLICK ,onClickSound,false,0,true );
			btn_help.addEventListener(MouseEvent.CLICK ,onClickHelp,false,0,true );
			mc_popup_help.btn_close.addEventListener(MouseEvent.CLICK ,onClickCloseHelp,false,0,true );
			mc_popup.btn_replay.addEventListener(MouseEvent.CLICK,onClickReplay,false,0,true);
			mc_popup.btn_reprendre.addEventListener(MouseEvent.CLICK,onClickReprendre,false,0,true);
			mc_popup.btn_home.addEventListener(MouseEvent.CLICK,onClickHome,false,0,true);
			view.stage.addEventListener(KeyboardEvent.KEY_UP,onKeybUp);
		}
		
		protected function onClickCloseHelp(event:MouseEvent):void
		{
			signal.dispatch("reprendre");
			SoundManager.getInstance().setGlobalVolume(0.6);
			
		}
		
		protected function onClickHelp(event:MouseEvent):void
		{
			TweenLite.to(mc_help,0.4,{alpha:1,y:0});
			signal.dispatch("pause");
			SoundManager.getInstance().setGlobalVolume(0.2);
			
		}
		
		protected function onKeybUp(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE && view.visible){
			   if(isPaused){
				   onClickReprendre(null);
			   }else
				onClickPause(null);
			}
			
		}
		
		protected function onClickSound(event:MouseEvent):void
		{
			soundMute=!soundMute; 
			
			SoundManager.getInstance().muteAll(soundMute);
			if(!soundMute){
				SoundManager.getInstance().setGlobalVolume(0.4);	
			}
		}
		
		private function animateOut():void
		{
			TweenLite.to(mc_popup,0.5,{y:-700});
			SoundManager.getInstance().setGlobalVolume(0.6);
		}
		
		protected function onClickHome(event:MouseEvent):void
		{
			animateOut();
			signal.dispatch("home");
			
		}
		
		
		
		protected function onClickReprendre(event:MouseEvent):void
		{
			animateOut();
			signal.dispatch("reprendre");
		    isPaused=false
		}
		
		protected function onClickReplay(event:MouseEvent):void
		{
			animateOut()
			signal.dispatch("replay");
		}
		
		protected function onClickPause(event:MouseEvent):void
		{
			 TweenLite.to(mc_popup,0.5,{y:0});
			 signal.dispatch("pause");
			 SoundManager.getInstance().setGlobalVolume(0.2);
			 isPaused=true;
			
		}
		public function getLettre(lettre:String):void{
			switch(lettre)
			{
				case "a":
				{
					MovieClip(mc_aicha.mc_a1.getChildAt(1)).visible= true;
					MovieClip(mc_aicha.mc_a2.getChildAt(1)).visible= true;
					break;
				}
				case "i":
				{
					MovieClip(mc_aicha.mc_i.getChildAt(1)).visible= true;
					 
					break;
				}
				case "h":
				{
					MovieClip(mc_aicha.mc_h.getChildAt(1)).visible= true;
					
					break;
				}
				case "c":
				{
					MovieClip(mc_aicha.mc_c.getChildAt(1)).visible= true;
					
					break;
				}
				case "reset":
				{
					initLettres();
					
					break;
				}	
					
				default:
				{
					break;
				}
			}
		}
		
		private function initial():void
		{
			setScore("0");
			setTime("0");
			setFruit("0");
			setLife(3);
			
			
		}
		public function setTime(time:String):void{
			txt_time.text=time;
		}
		
		public function setLife(life:int):void{
			mc_lives.gotoAndStop(life+1);
		}
		public function setScore(score:String):void{
			txt_score.text=score+" pts";
		}
		
		public function setFruit(fruit:String):void
		{
			txt_bonus.text="x "+fruit;
			
		}
	}
}