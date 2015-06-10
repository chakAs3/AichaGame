package myobjects.sparks
{
	import com.citrusengine.objects.CitrusSprite;
	
	import flash.utils.setTimeout;
	
	public class Sparks extends CitrusSprite
	{
		[Inspectable(defaultValue="3")] 
		public var duration:int=400;
		public function Sparks(name:String, params:Object=null)
		{
			super(name, params);
			setTimeout(function(){ kill=true },duration);
		}
	}
}