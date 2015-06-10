package register.classement
{
	 
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GradientGlowFilter;
	import flash.text.TextField;
	
	import myobjects.model.GameModel;
	
	public class ClassementItem extends Sprite
	{
		public var txt_num:TextField;
		public var txt_name:TextField;
		public var txt_score:TextField;
		public var mc_puce:Sprite;
		public var mc_fond:MovieClip;
		public function ClassementItem(data:Object,view:*)
		{
			super();
			
			txt_num = view.getChildByName("txt_num");
			txt_name = view.getChildByName("txt_name");
			txt_score = view.getChildByName("txt_score");
			mc_fond = view.getChildByName("mc_fond");
			
			
			trace( this +"  "+txt_num+"   "+txt_name+"   "+txt_score);
			//var filter:*=txt_score.filters[1];
			mc_fond.gotoAndStop(1);
			if(data){
				txt_num.text=data.id;
				txt_name.text=data.user;
				txt_score.text= GameModel.numberFormat(data.score) +" pts";
			}
			//if(int(data.current)==1)
				//isCurrentUser();
			//else
				//txt_score.filters=[filter];	
			
			 addChild(view);
			 view.visible=true;
		}
		
		public function isCurrentUser():void
		{
			//var filter:GradientGlowFilter=new GradientGlowFilter(0,90,[0xFFFFFF,0xFFFFFF],[1,1],null,4,4,300);
			/*txt_name.filters=[txt_score.filters[0]];
			txt_num.filters=[txt_score.filters[0]];
			txt_name.textColor=0xC21078;
			txt_num.textColor=0xC21078;
			txt_score.textColor=0xC21078;*/
			
		}
	}
}