package {

	import com.citrusengine.utils.AGameData;

	/**
	 * @author Aymeric
	 */
	public class MyGameData extends AGameData {

		private var _fruit:int=0;
		private var _letters:Array;
		public var allFruits:Boolean=false;
		public var superCoinTaked:int=0;
		
		public var fruit_score:int = 0; 
		public var enemies_score:int = 0; 
		public static var SCORE_PECHE:int=100;
		public static var SCORE_POMME:int=200;
		public static var SCORE_POIRE:int=400;
		public static var SCORE_LETTER:int=1000;
		public static var SCORE_SUPER_COIN:int=2000;
		public static var MAX_TIME:int=60000*5;
		public static var SCORE_TIME:int=10;
		public var score_time:int=0;
		
		public var level:int=1;
		
		public function MyGameData() {
			
			super();
			
			_levels =   [[ Level1 , "levels/A1/LevelA1.swf"],[ Level1, "levels/A1/LevelA2.swf"],  [ Level1 , "levels/A1/LevelA3.swf"],
			            
				[ Level1, "levels/B1/LevelB1.swf"],[ Level1 , "levels/B1/LevelB2.swf"],  [ Level1 , "levels/B1/LevelB3.swf"] ,
				
				[ Level1, "levels/C1/LevelC1.swf"],[ Level1 , "levels/C1/LevelC2.swf"],  [ Level1 , "levels/C1/LevelC3.swf"] ,
				
				[ Level1, "levels/D1/LevelD1.swf"],[ Level1 , "levels/D1/LevelD2.swf"],  [ Level3 , "levels/D1/LevelD3.swf"]];
		
		    letters=[] ;
		
		}
		
		public function get letters():Array
		{
			return _letters;
		}

		public function set letters(value:Array):void
		{
			_letters = value;
		}

		public function get fruit():int
		{
			return _fruit;
		}

		public function set fruit(value:int):void
		{
			_fruit = value;
			
			dataChanged.dispatch("fruit", _fruit);
		}

		public function get levels():Array {
			return _levels;
		}
		
		public function addLettre(lettre:String):void{
			
			trace(this+"addLettre  "+lettre+"  "+letters);
			letters.push(lettre);
			if(lettre=="reset"){
				letters=[];
				fruit_score=0;
			}
			dataChanged.dispatch("addletter", lettre);
		}

		override public function destroy():void {
			
			super.destroy();
		}
		
		

		public  function resetData():void
		{
			score = 0;
			score_time = 0;
			superCoinTaked = 0;
			fruit = 0;
			allFruits = false;
			letters=[];
			addLettre("reset");
			fruit_score=0;
			enemies_score=0
			
		}
	}
}
