package emagin.components.scroller{
	
	import caurina.transitions.Tweener;
	import flash.events.*;
	import flash.display.*;
	import flash.geom.Rectangle;
	
	//import GenericScrollbarEvent;
	
	public class GenericScrollbar extends EventDispatcher 
    {
		private var _track:Sprite;
		private var _button:Sprite;
		private var stage:Stage = null;
		
		public function GenericScrollbar(stage:Stage, track:Sprite, button:Sprite) {
			this.stage = stage;
			this._track = track;
			this._button = button;
			
			this._button.addEventListener(MouseEvent.MOUSE_DOWN, handleButtonDown);			
			this._track.addEventListener(MouseEvent.MOUSE_DOWN, handleButtonDown);			
		}
		

		private var _minimum:Number = 0;
		public function get minimum() {
			return _minimum;
		}
		
		public function set minimum(newValue:Number) {
			_minimum = newValue;
			positionButton();			
		}
	
		private var _maximum:Number = 0;	
		public function get maximum() {
			return _maximum;
		}
		
		public function set maximum(newValue:Number) {
			_maximum = newValue;
			positionButton();
		}
		
		
		private var _value:Number = 0;
		public function get value(){
			return _value;
		}
		
		public function set value(newValue:Number) {
			_value = newValue;
			
			positionButton();
		}		
		
		
		private function positionButton() {
			//_button.x =  _track.x + (value-minimum)/(maximum-minimum)*(_track.width-_button.width);
			if(!stage.hasEventListener(MouseEvent.MOUSE_MOVE))
			Tweener.addTween(_button,{x: _track.x + (value-minimum)/(maximum-minimum)*(_track.width-_button.width),time:0.5});
		}
		
		protected function doDrag(e:MouseEvent):void {
			
			calculateValue(_track.mouseX);
		}		
		
		protected function calculateValue(mousePos:Number) {
			
			if (mousePos < 0 || mousePos > _track.width)
				return;
			
			var newValue:Number = (mousePos-_button.width/2)/(_track.width-_button.width)*(maximum-minimum);
			
			// the private property
			
			doSetValue(newValue);
			

		}
		
		protected function doSetValue(newValue:Number) {
			var oldVal:Number = _value;
			
			// new value
			_value = Math.max(minimum, Math.min(maximum, Math.round( newValue )));

			dispatchEvent(new GenericScrollbarEvent(GenericScrollbarEvent.CHANGE, value));			
			
			positionButton();			
		}
		
		private function handleButtonDown(e:MouseEvent) {
			 _button.startDrag(false,new Rectangle(_track.x,6,_track.width-_button.width,0));
			 stage.addEventListener(MouseEvent.MOUSE_MOVE, doDrag,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleButtonUp,false,0,true);
			calculateValue(_track.mouseX);				
			
			
		}
		
		private function handleButtonUp(e:MouseEvent) {
			_button.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, doDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleButtonUp);			
			
			// fire change event
			dispatchEvent(new GenericScrollbarEvent(GenericScrollbarEvent.CHANGE, value));
		}
		
		
		
	}
	
	
	
}