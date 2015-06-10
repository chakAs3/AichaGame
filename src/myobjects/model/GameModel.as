package myobjects.model
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;

	public class GameModel extends Object
	{
		public static const NGIRO:int=6;
		public static const KFIZO:int=0;
		public static const KRICHO:int=4;
		public static const FHIMO:int=2;
		public static const FRI7O:int=3;
		public static const KSILO:int=5;
		public static const HCHIMO:int=1;
		public static var userInfo:Object={email:"javachakir@gmail.com"};
		public static var key:String="jdidalia";
		
		public function GameModel()
		{
			super();
			 
		}
		public static function encrypt(txt:String = ''):String
		{
			var type:String='simple-des-ecb';
			var key :ByteArray= Hex.toArray(Hex.fromString(GameModel.key));
			var data:ByteArray = Hex.toArray(Hex.fromString(txt));
			
			var pad:IPad = new PKCS5;
			var mode:ICipher = Crypto.getCipher(type, key, pad);
			pad.setBlockSize(mode.getBlockSize());
			mode.encrypt(data);
			return Base64.encodeByteArray(data);
		}
		public static function decrypt(txt:String = ''):String
		{
			var type:String='simple-des-ecb';
			var key :ByteArray= Hex.toArray(Hex.fromString(GameModel.key));
			var data:ByteArray = Base64.decodeToByteArray(txt);
			var pad:IPad = new PKCS5;
			var mode:ICipher = Crypto.getCipher(type, key, pad);
			pad.setBlockSize(mode.getBlockSize());
			mode.decrypt(data);
			return Hex.toString(Hex.fromArray(data));
		}
		public static function numberFormat(number:*, maxDecimals:int = 2, forceDecimals:Boolean = false, siStyle:Boolean = true, forceLength:uint = 0, indentUnit:String = " "):String {
			var i:int = 0, inc:Number = Math.pow(10, maxDecimals), str:String = String(Math.round(inc * Number(number))/inc), indent:String = "";
			var hasSep:Boolean = str.indexOf(".") == -1, sep:int = hasSep ? str.length : str.indexOf(".");
			var ret:String = (hasSep && !forceDecimals ? "" : (siStyle ? "," : " ")) + str.substr(sep+1);
			if (forceDecimals) for (var j:int = 0; j <= maxDecimals - (str.length - (hasSep ? sep-1 : sep)); j++) ret += "0";
			while (i + 3 < (str.substr(0, 1) == "-" ? sep-1 : sep)) ret = (siStyle ? " " : ",") + str.substr(sep - (i += 3), 3) + ret;
			if(forceLength != 0) for(j = sep + i / 3; j < forceLength; j++) indent += indentUnit;
			return indent + str.substr(0, sep - i) + ret;
		}
	}
}