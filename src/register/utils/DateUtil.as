package emagin.utils 
{
	
	/**
	 * ...
	 * @author ©haki®
	 */
	public class DateUtil 
	{
		public static var mois:Array = ["Jan", "Fev", "Mar", "Avr", "Mai", "Jui", "Juil", "Aou", "Sept", "Oct", "Nov", "Dec"];
		public static var jours:Array = ["Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"];
		public function DateUtil() 
		{
			
		}
		public static function getDifference(date_debut:Date , date_fin:Date):uint {
			return Math.floor(Math.abs((date_fin.time - date_debut.time) / 86400000)); 
		}
		public static function getDifferenceSign(date_debut:Date , date_fin:Date):uint {
			return Math.floor( (date_fin.time - date_debut.time) / 86400000); 
		}
		
	}
	
}