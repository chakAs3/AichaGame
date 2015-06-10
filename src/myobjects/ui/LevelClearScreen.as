package myobjects.ui
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Strong;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import myobjects.Utils;
	import myobjects.model.GameModel;
	
	import org.osflash.signals.Signal;
	
	import xml.SendScore;
	import xml.events.LoadEvent;
	
	public class LevelClearScreen extends Sprite
	{
		
		public var txt_score:TextField;
		public var mc_score_stars:MovieClip
		public var txt_score_time:TextField;
		public var txt_time:TextField
		public var btn_share:SimpleButton;
		public var btn_replay:SimpleButton;
		public var btn_next:SimpleButton;
		
		public var restartSignal:Signal ;
		public var nextSignal:Signal;
		
		public var view:*;
		private var mc_aicha:MovieClip;
		private var mc_hearder:DisplayObject;

		private var buttons:Array;
		public var signal:Signal;
		private var btn_close:SimpleButton;
		private var txt_score_enemy:Object;
		private var mc_end:MovieClip;
		private var data:MyGameData;
		private var score:String;
		public function LevelClearScreen(view:*)
		{
			super();
			this.view = view;
			
			mc_hearder = view.getChildByName("mc_header");
			txt_score = view.getChildByName("txt_score");
			mc_score_stars = view.getChildByName("mc_score_stars");
			txt_score_time = view.getChildByName("txt_score_time");
			txt_time = view.getChildByName("txt_time");
			txt_score_enemy = view.getChildByName("txt_score_enemy");
			
			mc_end = view.getChildByName("mc_end"); 
			
			
			btn_replay = view.getChildByName("btn_replay");
			btn_next = view.getChildByName("btn_next");
			btn_share = view.getChildByName("btn_share");
			btn_close = view.getChildByName("btn_close");
			buttons=[btn_share,btn_replay,btn_next];
			
			initialize();
			initLettres();
			setListeners();
			
			addChild(view);
		}
		private function initialize():void{
			mc_score_stars.mc_fruit.mc_star.gotoAndStop(1);
			mc_score_stars.mc_letters.mc_star.gotoAndStop(1);
			mc_score_stars.mc_supercoin.mc_star.gotoAndStop(1);
			mc_aicha=mc_score_stars.mc_letters.mc_aicha;
			
			mc_end.gotoAndStop(1);
		}
		public function setListeners():void{
			nextSignal=new Signal();
			restartSignal= new Signal();
			signal = new Signal();
			btn_next.addEventListener(MouseEvent.CLICK,onClickNext,false,0,true);
			btn_replay.addEventListener(MouseEvent.CLICK,onClickReplay,false,0,true);
			btn_close.addEventListener(MouseEvent.CLICK,onClickClose,false,0,true);
			btn_share.addEventListener(MouseEvent.CLICK,onClickShare,false,0,true);
		}
		
		protected function onClickShare(event:MouseEvent):void
		{
			trace(this+" score  "+score+" data.score:  "+data.score)
			if(ExternalInterface.available)
			ExternalInterface.call("fbPartage",score);
			
		}
		
		protected function onClickClose(event:MouseEvent):void
		{
			animateOut();
			signal.dispatch("home");
			
		}
		
		protected function onClickReplay(event:MouseEvent):void
		{
			
			animateOut();
			setTimeout(restartSignal.dispatch,300);
			
		}
		
		private function animateOut():void
		{
			TweenLite.to(this,0.4,{y:800,alpha:0,onComplete:onCompleteAnimeOut});
			
		}
		
		private function onCompleteAnimeOut():void
		{
			if(parent)
			parent.removeChild(this);
			 
			destroy()
		}
		
		protected function onClickNext(event:MouseEvent):void
		{
			 animateOut();
			setTimeout(nextSignal.dispatch,300)
			 
			
		}
		public function setData(data:MyGameData,end:Boolean=false):void{
			this.data=data;
			txt_time.text = "" + Utils.getTimeFormat(data.timeleft) ;
			txt_score_time.text= " "+data.score_time+" pts";
			txt_score.text =  data.score+" pts";
			txt_score_enemy.text = data.score-data.score_time-data.fruit_score-(data.letters.length*MyGameData.SCORE_LETTER)-(data.superCoinTaked*MyGameData.SCORE_SUPER_COIN)+" pts";
			
			mc_score_stars.mc_letters.txt_score.text=""+data.letters.length*MyGameData.SCORE_LETTER+" pts";
			mc_score_stars.mc_supercoin.txt_score.text=""+data.superCoinTaked*MyGameData.SCORE_SUPER_COIN+ " pts";
			mc_score_stars.mc_fruit.txt_score.text=""+data.fruit_score+" pts"
			if(data.allFruits){
			    mc_score_stars.mc_fruit.mc_star.gotoAndStop(2); 
			}
			if(data.superCoinTaked){
				mc_score_stars.mc_supercoin.mc_star.gotoAndStop(2);	
			}
			if(data.letters.length >= 4){
				mc_score_stars.mc_letters.mc_star.gotoAndStop(2);
			}
			
			for (var i:int = 0; i < data.letters.length; i++) 
			{
				getLettre(data.letters[i]);
			}
			animateIn();
			score = data.score+""; 
			saveScore(data);
			if(end){
				btn_next.visible=false;
				btn_replay.visible=false;
				setTimeout(function(){  showEndGame()   }
					
					,5000 );
			   }
			
		}
		private function showEndGame():void
		{
			TweenLite.to(mc_end,0.5,{y:0});
			mc_end.play();
			setTimeout(function(){mc_end.stop(),setTimeout(onClickClose,4000,null)},3000);
			
		}
		public function animateIn():void
		{
			TweenLite.from(this,0.5,{y:-height,alpha:0,ease:Strong.easeOut});
			TweenLite.from(mc_hearder,0.4,{y:-mc_hearder.height,alpha:0.3,ease:Bounce.easeOut,delay:0.4});
			TweenLite.from(mc_score_stars,0.4,{alpha:0,ease:Strong.easeOut,delay:0.6});
			TweenLite.from(txt_time,0.4,{alpha:0,ease:Strong.easeOut,delay:0.8});
			TweenLite.from(txt_score_enemy,0.4,{alpha:0,ease:Strong.easeOut,delay:0.9});
			TweenLite.from(txt_score_time,0.4,{alpha:0,ease:Strong.easeOut,delay:1});
			TweenLite.from(txt_score,0.4,{alpha:0,ease:Strong.easeOut,delay:1.2});
			for (var i:int = 0; i < buttons.length; i++) 
			{
				TweenLite.from(buttons[i],0.4,{y:buttons[i].y-10,alpha:0,ease:Strong.easeOut,delay:1.2+0.1*i});
			}
			TweenLite.from(mc_score_stars.mc_fruit.mc_star,0.4,{alpha:0,scaleX:1.5,scaleY:1.2,ease:Strong.easeOut,delay:1.6});
			TweenLite.from(mc_score_stars.mc_letters.mc_star,0.4,{alpha:0,scaleX:1.5,scaleY:1.2,ease:Strong.easeOut,delay:1.8});
			TweenLite.from(mc_score_stars.mc_supercoin.mc_star,0.4,{alpha:0,scaleX:1.5,scaleY:1.2,ease:Strong.easeOut,delay:2});
			
		}
		
		private function saveScore(data:MyGameData):void
		{
			
			var raja:String=GameModel.userInfo.email+"|"+data.level+"|"+data.score+"|"+data.fruit_score+"+"+data.enemies_score+"+"+data.score_time  ;
			var saveScore:SendScore=new SendScore({email:GameModel.userInfo.email,score:data.score,level:data.level,star_fruit:data.allFruits,star_letters:(data.letters.length >= 4),star_super:(data.superCoinTaked==1),duration:data.timeleft,raja:raja})
			    saveScore.addEventListener(LoadEvent.RESULTAS_RESPONSE,onResultatSave);
		}
		
		protected function onResultatSave(event:LoadEvent):void
		{
			trace("stage saved "+event.load_data.message)
			
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
		
		public function destroy():void{
			nextSignal.removeAll()
			restartSignal.removeAll()
		    signal.removeAll();
			btn_next.removeEventListener(MouseEvent.CLICK,onClickNext,false );
			btn_replay.removeEventListener(MouseEvent.CLICK,onClickReplay,false );
		}
	}
}