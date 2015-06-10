package myobjects.rewards
{
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.core.State;
	import com.citrusengine.objects.platformer.box2d.Coin;
	import com.citrusengine.objects.platformer.box2d.Hero;
	
	import flash.sampler.getInvocationCount;
	import flash.utils.setTimeout;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	 
	
	public class MyCoin extends Coin
	{
		private var _collectorClass:Class = Hero;
		private var ce:CitrusEngine;
		private var taked:Boolean=false;
		
		[Inspectable(defaultValue="")]
		public var char:String="";
		
		public function MyCoin(name:String, params:Object=null)
		{
			super(name, params);
			ce=CitrusEngine.getInstance();
			trace(this+" char "+char)
		}
		override public function update(timeDelta:Number):void
		{
			//update(timeDelta);
			if(view=="levels/common/Supercoin.swf"){
				if(!visible && ce.gameData.superBonusVisible){
					group=3;
				}
					
			   visible=ce.gameData.superBonusVisible || taked;
			   
			}
				
			updateAnimation(); 
			
		}
		private function updateAnimation():void{
			if(kill){
				_animation="exploded";
			}else{
				_animation="normal";
			}
		}
		override protected function handleBeginContact(e:ContactEvent):void
		{
			//super.handleBeginContact(e);
			//trace(this+"  handleBeginContact  ")
			
			if (_collectorClass && e.other.GetBody().GetUserData() is _collectorClass && !taked)
			{
				
				if(view=="levels/common/Supercoin.swf" ){
					
					SoundManager.getInstance().playSound("supercoin",1,1);
					MyGameData(ce.gameData).superCoinTaked=1;
				}else{
					
					SoundManager.getInstance().playSound("eat",1,1);
					
				}
				
				var tween:Tween = new Tween(this, 0.5, Transitions.EASE_OUT);
				if(char!=""){
					tween.animate("x", this.x );
					tween.animate("y", 200);
				}else{
				   tween.animate("x", this.x + 360);
				   tween.animate("y", 870);
				}
				
				
				taked=true;
				group=3;
				tween.onComplete=function():void
				{ 
					
					if(view=="levels/common/Supercoin.swf" ){
						
						SoundManager.getInstance().playSound("supercoin",1,1);
						ce.gameData.score+=	MyGameData.SCORE_SUPER_COIN ;
						
					}else if(char==""){
						
						MyGameData(ce.gameData).fruit++;
						var fruitscore:int=0;
						switch(view)
						{
							case "levels/common/Peche.swf":
							{
								fruitscore=MyGameData.SCORE_PECHE //	100 ;
								break;
							}
							case "levels/common/Pomme.swf":
							{
								fruitscore=	MyGameData.SCORE_POMME // 200  ;
								break;
							}
							case "levels/common/Poire.swf":
							{
								fruitscore=	MyGameData.SCORE_POIRE // 400 ;
								break;
							}
								
							default:
							{
								break;
							}
						}
						ce.gameData.score+=fruitscore;
						MyGameData(ce.gameData).fruit_score+=fruitscore;
						 
						
					} else if(char!="") { // letters aicha 
						ce.gameData.score+=	MyGameData.SCORE_LETTER ;
						//trace(" ____char "+char)
						MyGameData(ce.gameData).addLettre(char);
					}
					
					kill = true;   
				} ;  
				Starling.juggler.add(tween); 
               
			}
		}
	}
}