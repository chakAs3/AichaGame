package myobjects
{
	public class Utils
	{
		public function Utils()
		{
		}
		public static function getTimeFormat(milisecondes:int):String
		{
			//trace(" getTimeFormat  "+milisecondes)
			var current_mili=(milisecondes%1000);
			var secondes:int=int(milisecondes/1000);
			var total_current_seconds:Number = secondes;
			var current_hours = Math.floor(total_current_seconds/3600);
			var current_minutes= Math.floor(total_current_seconds/60)%60;
			var current_seconds = Math.floor(total_current_seconds)%60;
			//var current_mili=Math.floor((MATH_TIME*100-getMili()/10))%100;
			
			//trace("1-"+current_seconds);
			if(current_hours < 10) 
				current_hours = "0" + current_hours;
			if(current_minutes < 10) 
				current_minutes = "0" + current_minutes;
			if(current_seconds < 10) 
				current_seconds = "0" + current_seconds;
			if(current_mili < 100 && current_mili >=10) 
				current_mili = "0" + current_mili;
			//if(current_mili < 10) 
			//current_mili = "00" + current_mili;
			
			//trace("   2 -"+ current_seconds );
			
			return current_minutes+":"+current_seconds//+":"+current_mili;
			
			//return getMili()+"";
		}
	}
}