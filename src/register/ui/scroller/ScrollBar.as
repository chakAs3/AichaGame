package emagin.components.scroller {
	import flash.display.Sprite;

	/**
	 * @author emagin
	 */
	public class ScrollBar extends Sprite {
		public var mc_bar_drag:Sprite;
		public function ScrollBar() {
			mc_bar_drag.visible=false
		}

		public function setWidth(w:int):void {
			mc_fond.width = w;
			right.x = w - right.width-2;
		}
	}
}