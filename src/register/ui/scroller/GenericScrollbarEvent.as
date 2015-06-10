/**************************************
title: CoverFlow knockoff
author: John Dyer (johndyer.name)
license: MIT
*************************************/

package emagin.components.scroller
{	
    import flash.events.*;

	
	public class GenericScrollbarEvent extends Event {
		
		public static var CHANGE:String = "scrollChange";

		public var value:Number = -1;
		
		function GenericScrollbarEvent(type:String, value:Number)  {
			super(type);
			this.value = value;
		}
	}
	
}