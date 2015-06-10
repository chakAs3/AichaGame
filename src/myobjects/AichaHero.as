package myobjects
{
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.objects.Box2DPhysicsObject;
	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.platformer.box2d.Crate;
	import com.citrusengine.objects.platformer.box2d.Hero;
	import com.citrusengine.objects.platformer.box2d.Missile;
	import com.citrusengine.utils.LevelManager;
	import com.citrusengine.view.starlingview.StarlingArt;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import myobjects.enemies.FishEnemy;
	import myobjects.enemies.MonkeyEnemy;
	import myobjects.enemies.PlatformEnemy;
	import myobjects.model.GameModel;
	
	public class AichaHero extends Hero
	{
		
		private var _falling:Boolean;

		private var lastPositionY:Number;
		public var currentHero:int=0;
		private var _special:Boolean;
		public var specials:Array=["jump","run","secret","shoot","push","duck","absorb"];
		private var currentCollider:MyCrate;
		private var _firing:Boolean;

		private var timerFire:Timer;
		public var sprites:SpritesHeros;
		private var objectOnTopDuking:Box2DPhysicsObject;

		private var soundManager:SoundManager;
		private var _die:Boolean;
		private var _protected:Boolean;

		private var maskSuperCoin:CitrusSprite;
		private var _dieDuration:int;
		private var _venerabilityDuration:int=3000;

		private var _timerOut:*;

		private var _venerable:Boolean;
		
		public function AichaHero(name:String, params:Object=null)
		{
			super(name, params);
			timerFire=new Timer(900);
			timerFire.addEventListener(TimerEvent.TIMER,_fire);
			soundManager=SoundManager.getInstance();
			hurtVelocityY=2;
			_dieDuration=4000;
			onTakeDamage.add(onDommageHero);
			
		}
		
		private function onDommageHero():void
		{
			if( _special  && currentHero==GameModel.NGIRO ) return ;
			CitrusEngine.getInstance().gameData.lives--;
			if( CitrusEngine.getInstance().gameData.lives<=0 && !_die ){
				_die=true
				controlsEnabled=false;
				soundManager.playSound("die",0.6,2); 
				setTimeout(dieFinish,_dieDuration);
			}
			
		}
		
		private function dieFinish():void
		{
			CitrusEngine.getInstance().gameData.lives=3;
			//LevelManager.getInstance().gotoLevel();
			(_ce.state as ALevel).restartLevel.dispatch();
		 
		}
		override public function update(timeDelta:Number):void
		{
			var velocity:V2 = _body.GetLinearVelocity();
			
			maxVelocity=4;
			_special=false;
			_ce.gameData.superBonusVisible=false;
			if(!maskSuperCoin)
			maskSuperCoin=(_ce.state.getObjectByName("maskcoin") as CitrusSprite);
			maskSuperCoin.visible=false;
			
			// hero die if is falling under 
			
			if( this.y > 1700 && !_die  ) {
				_die=true;
				dieFinish();
			}
			
			if (controlsEnabled && !_die)
			{
			 
				var moveKeyPressed:Boolean = false;
				
				_ducking = (_ce.input.isDown(Keyboard.SPACE) && currentHero == GameModel.KSILO && _onGround && canDuck);
				_falling = velocity.y > 3  ;
				
				if( _onGround && _ce.input.isDown(Keyboard.SPACE) ){
					
					_special=true;
					
					if( currentHero == GameModel.KRICHO  ){
						if( currentCollider )
							currentCollider.canMoved(true);  // kricho can move the crate
						else
						   _special=false;                  // disabled special move animation
					}else if(currentHero == GameModel.HCHIMO){
						maxVelocity= 10;	
					}else if( currentHero == GameModel.FRI7O ){
						if(!_firing)
						startFiring();
					}else if (currentHero == GameModel.KSILO  ){
						maxVelocity = 2 ;
					}else if ( currentHero == GameModel.NGIRO ){
						_protected=true;
					}else if( currentHero == GameModel.FHIMO ){
						maskSuperCoin.x = x - 400	;
						maskSuperCoin.y = y - 480;
						maskSuperCoin.visible=true;
						_ce.gameData.superBonusVisible=true
					}
					 
				}else if(!_ce.input.isDown(Keyboard.SPACE)){
					//if( currentHero == GameModel.FRI7O ){
						if( _firing )
						stopFiring();
					//}
				}
				
				if (_ce.input.isDown(Keyboard.RIGHT)  && canMove())
				{
					velocity = V2.add(velocity, getSlopeBasedMoveAngle());
					moveKeyPressed = true;
				}
				
				if (_ce.input.isDown(Keyboard.LEFT)  &&  canMove())
				{
					velocity = V2.subtract(velocity, getSlopeBasedMoveAngle());
					moveKeyPressed = true;
				}
				
				//If player just started moving the hero this tick.
				if (moveKeyPressed && !_playerMovingHero)
				{
					_playerMovingHero = true;
					_fixture.SetFriction(0); //Take away friction so he can accelerate.
				}
					//Player just stopped moving the hero this tick.
				else if (!moveKeyPressed && _playerMovingHero)
				{
					_playerMovingHero = false;
					_fixture.SetFriction(_friction); //Add friction so that he stops running
				}
				
				if (_onGround && _ce.input.justPressed(Keyboard.SPACE) && !_ducking)
				{
					if(currentHero==GameModel.KFIZO){
					   velocity.y = -jumpHeight;
					   onJump.dispatch();
					} 
					 
				}
				
				if (_ce.input.isDown(Keyboard.SPACE) && !_onGround && velocity.y < 0)
				{
					if(currentHero == GameModel.KFIZO)
					velocity.y -= jumpAcceleration;
					
				}
				
				if (_springOffEnemy != -1)
				{
					if (_ce.input.isDown(Keyboard.SPACE))
						velocity.y = -enemySpringJumpHeight;
					else
						velocity.y = -enemySpringHeight;
					_springOffEnemy = -1;
				}
				
				//Cap velocities
				if (velocity.x > (maxVelocity))
					velocity.x = maxVelocity;
				else if (velocity.x < (-maxVelocity))
					velocity.x = -maxVelocity;
				
				//update physics with new velocity
				_body.SetLinearVelocity(velocity);
			}
			
			updateAnimation();
		 
		
		}
		
		private function stopFiring():void
		{
			_firing=false;
			if(_timerOut){
				clearTimeout(_timerOut)
			}
			if(timerFire){
				timerFire.stop(); 	 
			}
			
		}
		
		private function startFiring():void
		{
		 
			_firing=true;
			_timerOut=setTimeout(function (){
				_fire(null);
				timerFire.start(); 
			},400);
			
		}
		
		private function canMove():Boolean
		{
			return !(_special && (currentHero == GameModel.FRI7O || currentHero == GameModel.FHIMO || currentHero == GameModel.NGIRO) || (!_special && currentHero == GameModel.KSILO && (_animation=="duck" || _animation=="duckidle" || _animation=="crouch") ))
			  
		}
		override protected function updateAnimation():void
		{
			var prevAnimation:String = _animation;
			
			var velocity:V2 = _body.GetLinearVelocity();
			if(_die){
				_animation = "die";
			}else
			if (_hurt)
			{
				_animation = "hurt";
			}
			else if (!_onGround)
			{
				if(velocity.y<-2  && currentHero == GameModel.KFIZO) 
				_animation = "jump";
				if(_falling)
					_animation = "fall";	
			}
			 
			else if(_special && currentHero != GameModel.KFIZO && currentHero != GameModel.HCHIMO || (GameModel.KSILO && objectOnTopDuking)){
				
				_animation = specials[currentHero];
				var walkingSpeed:Number = getWalkingSpeed();
				if (walkingSpeed < -acceleration)
				{
					_inverted = true;
					 
				}
				else if (walkingSpeed > acceleration)
				{
					_inverted = false;
			 
				}
				if(walkingSpeed!=0 && currentHero== GameModel.KSILO){
					
					_animation="crouch";
					
				}else if(walkingSpeed==0 && prevAnimation!="idle" && prevAnimation!="duck" && prevAnimation!="walk" && currentHero== GameModel.KSILO  ) {
					 
					_animation="duckidle"; 
					
				} 
			}
			else
			{
				var walkingSpeed:Number = getWalkingSpeed();
				if ( walkingSpeed < -acceleration)
				{
					_inverted = true;
					_animation =( walkingSpeed< -6 && currentHero==GameModel.HCHIMO)? "run":getWalkAnimation();
				}
				else if ( walkingSpeed > acceleration)
				{
					_inverted = false;
					_animation = ( walkingSpeed> 6 && currentHero==GameModel.HCHIMO )? "run":getWalkAnimation();
				}
				else
				{
					_animation = "idle";
				}
			}
			 
			/*if(_animation=="walk" && prevAnimation!="walk" ){
				soundManager.playSound("walk",1,99);
			}else if(_animation!="walk"){
				soundManager.stopSound("walk");
			}*/
			//trace(this+" _animation "+_animation)
			
			// venerability gestion
			visible=true;
			if(_venerable && !_die){
				visible=Math.random()<0.5;
			} 
			//
				
			 
			
			if ( prevAnimation != _animation )
			{
				onAnimationChange.dispatch();
				updateSound();
			}
		}
		
		public function updateSound():void{
			if(_animation=="jump"){
				soundManager.playSound("jump",1,1);
			}
		}
		
		private function getWalkAnimation():String{
			if(_special && currentHero== GameModel.KSILO){
				return "crouch";
			}
			return "walk";
		}
		
		override protected function handlePreSolve(e:ContactEvent):void 
		{
			if (!_ducking)
				return;
			
			var other:Box2DPhysicsObject = e.other.GetBody().GetUserData() as Box2DPhysicsObject;
			
			var heroTop:Number = y ;
			var objectBottom:Number = other.y + (other.height / 2);
			//e.contact.Disable();
			
			if (objectBottom < heroTop){
				e.contact.Disable();
				objectOnTopDuking=other; 
			}
		}
		
		override protected function handleBeginContact(e:ContactEvent):void
		{
			var collider:Box2DPhysicsObject = e.other.GetBody().GetUserData();
			if ((_enemyClass && collider is _enemyClass || collider is BallMonkey || collider is FishEnemy ) && ( _venerable || _die )){ // if the hero juste hurted time venerable
				e.contact.Disable();
				return ;
			}
			
			super.handleBeginContact(e);
			
			
			if ( collider is Crate)
			{  
				currentCollider=(collider as MyCrate)
				
				if( currentHero == GameModel.KRICHO  ){
					if(_special)
					currentCollider.canMoved(true);
				}
				 
			}
			if(!_die && collider is BallMonkey || collider is FishEnemy || collider is PlatformEnemy ){
				hurt();
			}
			
		}
		override protected function handleEndContact(e:ContactEvent):void
		{
			super.handleEndContact(e);
			var collider:Box2DPhysicsObject = e.other.GetBody().GetUserData();
			if ( collider is MyCrate)
			{
				//if(currentHero == GameModel.KRICHO){
					(collider as MyCrate).canMoved(false) ;
					currentCollider=null;
				//}
			}
			if(collider == objectOnTopDuking ){
				objectOnTopDuking=null;
				 
			}
		}
		
	    protected function _fire(tEvt:TimerEvent):void {
			
			if (_firing) {
				
				var missile:NoteMissile;
				
				if (! _inverted )
					missile = new NoteMissile("Missile", {x:x + width+20, y:y-20, group:group, width:20, height:20, offsetY:0, speed:3, angle:0, explodeDuration:200, fuseDuration:3500, view:( Math.random() > 0.5 ? sprites.getAnimationSequenceNote1(): sprites.getAnimationSequenceNote2()) });
				else
					missile = new NoteMissile("Missile", {x:x - width-20, y:y-20, group:group, width:20, height:20, offsetY:0, speed:-3, angle:0, explodeDuration:200, fuseDuration:3500, view:( Math.random() > 0.5 ? sprites.getAnimationSequenceNote1(): sprites.getAnimationSequenceNote2()) });
				
				_ce.state.add(missile);
			 
			}
		}
		
		override public function hurt():void
		{
			super.hurt();
			soundManager.playSound("hurt",0.8,1);
			_venerable=true;
			setTimeout(endVenerable,_venerabilityDuration);
		}
		
		private function endVenerable():void
		{
			_venerable=false;
			return ;
		}
		
		override public function destroy():void{
			if(timerFire){
				timerFire.stop();
				timerFire=null;
			}
			super.destroy();
		}
	}
}