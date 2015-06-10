package register.classement
{
	import com.greensock.TweenLite;
	import com.scroller.Scrollbar;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import register.events.RegisterEvent;
	import register.xml.LoadClassement;
	
	public class ClassementPanel extends Sprite
	{
		private var view:*;
		private var btn_close:SimpleButton;
		private var listeCLassment:*;
		private var mc_container:MovieClip;
		private var masque:MovieClip;
		private var barscroller:MovieClip;
		public var classItem:Class;
		private var userItem:ClassementItem;
		private var currentData:Object;
		
		
		public function ClassementPanel(view:*)
		{
			super();
			this.view = view;
			
			btn_close = view.getChildByName("btn_close");
			mc_container = view.getChildByName("mc_container");
			masque = view.getChildByName("masque");
			barscroller = view.getChildByName("barscroller");
			
			view.getChildByName("user_item").visible = false
			//mc_monde = view.getChildByName("mc_monde");
			addChild(view);
		}
		 
		 
		public function init():void{
			 
			btn_close.addEventListener(MouseEvent.CLICK,onClickCLose);
			loadData();
			
		}
		
		protected function onClickCLose(event:MouseEvent):void
		{
			dispatchEvent(new Event("closeClassement",true));
			parent.removeChild(this);
		}
		
		public function loadData(index:int=0):void{
			
			trace(this+" loadData ");
			var loadClassment:LoadClassement=new LoadClassement();
			loadClassment.addEventListener(RegisterEvent.LOAD_CLASSMENT,onLoadClassement);
			//currentIndexPeriode=index
		}
		
		protected function onLoadClassement(event:RegisterEvent):void
		{
			//clearContainer();
			listeCLassment=event.load_data as Array;
			trace(this+" onLoadClassement "+listeCLassment.length);
			//if(currentIndexPeriode==-1) currentIndexPeriode=listeCLassment.length-1;
			 
			//var dataClassementPeriode:Array=semain.items as Array
			 trace(this+""+listeCLassment)
			setData(listeCLassment);
			//createView();
			if(currentData){  
			userItem = new ClassementItem(currentData,view.getChildByName("user_item") );
			userItem.mc_fond.gotoAndStop(2);
			addChild(userItem);
			}
		}
		 
		public function setData(data:Array):void
		{
			trace(this+" data "+data );
			var item:ClassementItem
			for (var i:int = 0; i < data.length; i++) 
			{
				data[i].index=(i+1);
				item=new ClassementItem(data[i],new classItem() );
				item.y= i*(item.height+5);
				TweenLite.from(item,0.5,{alpha:0,y:item.y+10,delay:0.1*i});
				mc_container.addChild(item);
				if(data[i].current==1){
					currentData=data[i];
				}
			}
			
			//addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			createScroller();
		}
		
		protected function onAddedToStage(event:Event):void
		{
			trace(this+"onAddedToStage ");
			createScroller();
			
		}
		
		private function createScroller():void
		{
			var sc:Scrollbar=new Scrollbar(mc_container,masque,barscroller.sub,barscroller.bar,masque,true,2);
			addChild(sc);
			trace(this+" stage !!"+stage)
			sc.init();
			
		}
	}
}