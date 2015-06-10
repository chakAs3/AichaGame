package emagin.components.scroller 
{
	 
	import com.greensock.easing.Circ;
	import com.greensock.TweenLite;
	import emagin.components.ERectange;
	import emagin.components.scroller.events.EScrollerEvent;
	import flash.display.DisplayObject;
 	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	 
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Chakir
	 */
	public class EScroller extends Sprite
	{
		
		public var scroller_bar:ERectange;
		public var scroller_fond:ERectange;
		public var scrollTarget:DisplayObject;
		
		public var animated:Boolean=false;
		private var interval:int;
		public var bar_mask:ERectange;
		
		private var _ymin:int;
		private var _ymax:int;
		public static var SCROLL_ACTIVE:EScroller;
		private var msque:ERectange;
		public function EScroller(w:int=5,h:int=86,poucent:Number=0.2) 
		{
			
			
			scroller_fond = new ERectange(w, h,0x686868);
			//(scroller_fond as ERectange).setRound(20);
			
			addChild(scroller_fond);
			
			scroller_bar = new ERectange(w - 2, poucent * height, 0xFFFFFF)//,0x0079B3, true, [1, 0.4 ]);
			
			//var scroller_bar_fond:ERectange=new ERectange(w - 2, poucent * height, 0xD2D2D2);
			//scroller_bar.removeChildAt(0);
			//scroller_bar.addChildAt(scroller_bar_fond,0);
			//scroller_bar.mc_fond.height=scroller_bar.mc_degrade.height=scroller_bar_fond.height-2;
			scroller_bar.x = 1;
			scroller_bar.y = 1;
			scroller_bar.buttonMode = true;
			scroller_bar.alpha = 1;
			addChild(scroller_bar);
			scroller_bar.addEventListener(MouseEvent.MOUSE_DOWN, startDragBar);
			scroller_bar.addEventListener(MouseEvent.MOUSE_UP, stopDragBar);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			//scroller_bar.addEventListener(MouseEvent.ROLL_OUT, stopDragBar);
			animated = true;
			
			_ymin= scroller_fond.y//+1;
			_ymax= scroller_fond.height - scroller_bar.height-2 //- 1
		}
		
		private function onAdded(e:Event):void 
		{
			//stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		 // addWheelListener();
		// addWheelListener();
		}
		public function addWheelListener():void{
			//trace("addWheelListener");
			stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel)
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			//trace(this+" onMouseWheel "+e.delta+" SCROLL_ACTIVE  "+ SCROLL_ACTIVE.parent + " this  "+this.parent);
			if(SCROLL_ACTIVE  != this ) return 
			var value:Number=Number(scroller_bar.y)-e.delta;//(Math.abs(e.delta)/e.delta)*2.5
			scroller_bar.y=Math.min(_ymax+1,Math.max(value,_ymin));
			
			//onMMove(null);
			//if(!hasEventListener(Event.ENTER_FRAME))
			addEventListener(Event.ENTER_FRAME, onMMove);
			dispatchStartDrag();
			//dispatchEndDrag();
			var timer:Timer=new Timer(400,1)
			timer.addEventListener(TimerEvent.TIMER,onTimerEnd);
			timer.start();
		}
		
		private function onTimerEnd(e:TimerEvent):void 
		{
			dispatchEndDrag();
		}
		 
		private function dispatchStartDrag():void{
			var se:EScrollerEvent = new EScrollerEvent(EScrollerEvent.START_DRAG);
			dispatchEvent(se);
		}
		private function dispatchEndDrag():void{
			var se:EScrollerEvent = new EScrollerEvent(EScrollerEvent.END_DRAG);
			dispatchEvent(se);
		}
		
		private function upHandler(e:MouseEvent):void 
		{
			trace(this + " upHandler ");
			if(visible)
			if (e.eventPhase >= EventPhase.AT_TARGET ) {stopDragBar(null);onBarOut(null);}
		}
		private function startDragBar(em:MouseEvent):void {
		    
			setListeners();
			stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			var se:EScrollerEvent = new EScrollerEvent(EScrollerEvent.START_DRAG);
			dispatchEvent(se);
		}
		public function setListeners():void {
			
			scroller_bar.startDrag(false, new Rectangle(scroller_bar.x, scroller_fond.y+1, 0, scroller_fond.height - scroller_bar.height -1));
		 
			//addEventListener(MouseEvent.MOUSE_MOVE, onMMove);
			addEventListener(Event.ENTER_FRAME, onMMove);
		}
		public function stopDragBar(me:MouseEvent):void {
			
			scroller_bar.stopDrag();  
			if(scrollTarget)
			updateScrollerTarget();
			
			removeEventListener(Event.ENTER_FRAME, onMMove);
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			
			var se:EScrollerEvent = new EScrollerEvent(EScrollerEvent.END_DRAG);
			dispatchEvent(se);
		}
		public function setScrolTarget(mc:DisplayObject, hScroller:int):void {
			
			if ( mc.parent) {
				msque = new ERectange(mc.width+10, hScroller);
				
				mc.parent.addChild(msque);
				mc.mask = msque;
				msque.y = mc.y;
				msque.x = mc.x;
				scrollTarget = mc;
				var pr:Number = hScroller / mc.height;
				
				//scroller_bar.height = pr * scroller_fond.height - 2;
				ajustBarScrooller(pr * scroller_fond.height - 2);
				TweenLite.to(scroller_bar, 0.09,{ alpha :0.7  } );
				scroller_bar.addEventListener(MouseEvent.ROLL_OVER, onBarOver);
				scroller_bar.addEventListener(MouseEvent.ROLL_OUT, onBarOut);
				_ymax= scroller_fond.height - scroller_bar.height - 2;
				
			}
			if (mc.height < hScroller) { this.scroller_bar.visible = false; return; }
			
			scrollTarget.addEventListener(MouseEvent.ROLL_OVER,onClickScrollTarget)
		}
		public function ajustBarScrooller(h:Number):void {
			h = Math.max(h, 30);
			var scroller_bar_fond:ERectange=new ERectange(scroller_bar.width, h, 0xFFFFFF,0xFFFFFF);
			//scroller_bar_fond.setRound(20);
			//scroller_bar.getChildAt(0).alpha=0;
			
			scroller_bar.alpha=1
			//scroller_bar.getChildAt(0).height=h-1;
			scroller_bar.removeChildAt(0);
			scroller_bar.addChild(scroller_bar_fond);
			
			
			var bar_react:ERectange = new ERectange(10, h, 0xB1B456)
			bar_react.alpha=0.01
			bar_react.x=-3
			scroller_bar.addChild(bar_react);
			//scroller_bar.height=h;
		}
		
		private function onClickScrollTarget(e:MouseEvent):void 
		{
			SCROLL_ACTIVE=this;
		}
		
		private function onBarOut(e:MouseEvent):void 
		{
			//if(!stage.hasEventListener(MouseEvent.MOUSE_UP))
			TweenLite.to(scroller_bar, 0.9,{ alpha :0.7  } );
			 
		}
	
		private function onBarOver(e:MouseEvent):void 
		{
			TweenLite.to(scroller_bar,0.9, { alpha :1  } );
			 SCROLL_ACTIVE=this;
		}
		private function onMMove(em:Event):void {
			if (!scrollTarget) return;
			var event:EScrollerEvent = new EScrollerEvent(EScrollerEvent.WHILE_DRAG);
			event.drag_value = int( scroller_bar.y / scroller_fond.height);
			//trace("Pourcent ...." +	event.drag_value+" mouseX  :"+mouseX);
		   // scrollTarget.y=int(-event.drag_value*scrollTarget.height)
		    updateScrollerTarget();
		//	dispatchEvent(event);
			 
		}
		public function updateScrollerTarget():void {
			//trace(this+" updateScrollerTarget ");
			var pourcent:Number = (scroller_bar.y) / (scroller_fond.height-scroller_bar.height);
			
		//	trace(this+"pourcent "+pourcent);
			var yy:int = -pourcent * (scrollTarget.height-scrollTarget.mask.height) + scrollTarget.mask.y ;
			var plus = (yy - scrollTarget.y) * 0.2;
			scrollTarget.y = Math.round(scrollTarget.y + plus);
			 TweenLite.to(scrollTarget,0.5,{y:yy,ease:Circ.easeOut});
			//trace("Plus :"+plus)
			//if(int(plus)==0)
			//removeEventListener(Event.ENTER_FRAME, onMMove);
			
		
		}
		public function updateHeightScroll(hScroller:int,hFondScroll:int):void{
			    msque.height=hScroller;
			    scroller_fond.height=hFondScroll;
			    var pr:Number = Math.min(hScroller / scrollTarget.height,1); 
			    scroller_bar.height = pr * scroller_fond.height - 2;
				_ymax= scroller_fond.height - scroller_bar.height - 6;
				if((scroller_bar.y+scroller_bar.height) > hScroller)
				scroller_bar.y=hScroller-scroller_bar.height;
				this.visible=true;;
				if(pr==1) {this.visible=false,scroller_bar.y=1};
				
		}
		public function setBarColor(color:int):void {
			var ct:ColorTransform = new ColorTransform(); 
			ct.color = color;
			
			scroller_bar.transform.colorTransform = ct;
			scroller_bar.alpha=.7
		}
		
	}
	
}