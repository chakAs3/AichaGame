package myobjects.model.vo
{
	public class LevelScore
	{
		public var score:int;
		public var fruits:int;
		public var star_fruit:Boolean;
		public var star_super:Boolean;
		public var star_letters:Boolean;
		public var active :Boolean ;
		public var name:Object;
		public var image:Object;
		public var id:int;
		public var monde:Object;
		public function LevelScore()
		{
		}
		 
		public function setFromXml(node:XML):void
		{
			    id=int(node.@id);
				monde=node.@monde;
				active=node.@active=="true";
			    name=node.name;
			    image=node.image
				score=int(node.score);
				star_fruit=(node.stars.@fruits=="true");
				star_letters=node.stars.@letters=="true";
				star_super=node.stars.@supercoin=="true";
		}
	}
}