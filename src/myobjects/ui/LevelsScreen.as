package myobjects.ui
{
	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.SoundManager;
	import com.citrusengine.utils.LevelManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import myobjects.model.vo.LevelScore;
	
	import org.osflash.signals.Signal;
	
	import xml.LoadLevels;
	import xml.events.LoadEvent;
	
	public class LevelsScreen extends Sprite
	{
		public var startSignal:Signal;
		private var mc_header:DisplayObject;
		private var view:*;
		private var btn_next:SimpleButton;
		private var btn_prev:SimpleButton;

		private var levelsData:Array;
		private var mc_monde:MovieClip;
		
		public var currentIndex:int=0;
		
		public var mondes:Array=[1,2,3,4];

		private var queue:LoaderMax;

		private var loadImage:ImageLoader;
		public var signal:Signal;
		private var btn_classment:SimpleButton;
		public function LevelsScreen(view:*)
		{
			super();
			this.view = view;
			
			mc_header = view.getChildByName("mc_header");
			btn_next = view.getChildByName("btn_next");
			btn_prev = view.getChildByName("btn_prev");
			mc_monde = view.getChildByName("mc_monde");
			btn_classment = view.getChildByName("btn_classement");
			
			btn_next.visible=btn_prev.visible=false;
			startSignal=new Signal();
			
			addChild(view);
			addlisteners();
			checkButtons();
			mc_monde.visible=false;
			
			//create a LoaderMax named "mainQueue" and set up onProgress, onComplete and onError listeners
			queue = new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
			
			//append several loaders
		 
			
		}
		function progressHandler(event:LoaderEvent):void {
			trace("progress: " + event.target.progress);
		}
		
		function completeHandler(event:LoaderEvent):void {
			 
			trace(event.target + " is complete!");
		}
		
		function errorHandler(event:LoaderEvent):void {
			trace("error occured with " + event.target + ": " + event.text);
		}
		public function loadData():void
		{
			var loadLevels:LoadLevels=new LoadLevels();
			loadLevels.addEventListener(LoadEvent.LOAD_LEVELS,onLoadLevels);
			
		}
		public function addlisteners():void{
			btn_next.addEventListener(MouseEvent.CLICK,onClickNExt);
			btn_prev.addEventListener(MouseEvent.CLICK,onClickPrev);
			btn_classment.addEventListener(MouseEvent.CLICK,onClickClassement);
			for (var i:int =1; i < 4; i++) 
			{
				
			 
				var levelItem:LevelItem=new LevelItem(mc_monde.getChildByName("mc_n"+i));
				levelItem.view.btn_start.addEventListener(MouseEvent.CLICK,onClickLevelItem);
				
			}
		}
		
		protected function onClickClassement(event:MouseEvent):void
		{
			startSignal.dispatch("classement");
			
		}
		
		protected function onClickLevelItem(event:Event):void
		{
			var item:*=event.currentTarget.parent ;
			CitrusEngine.getInstance().playing=true;
			setTimeout(LevelManager.getInstance().gotoLevel,600,int(item.num));
			//trace(this+" .name: "+(event.currentTarget.parent as DisplayObject).name);
			animateOut();
			
		}
		
		private function animateOut():void
		{
			TweenLite.to(this,0.5,{y:800,alpha:0,onComplete:destroy});
			
		}
		
		private function destroy():void
		{
			 
				
				parent.removeChild(this);
				removeListeners();
				queue.dispose();
				SoundManager.getInstance().stopSound("levels");
			 
		}
		private function removeListeners():void
		{
			btn_next.removeEventListener(MouseEvent.CLICK,onClickNExt);
			btn_prev.removeEventListener(MouseEvent.CLICK,onClickPrev);
			for (var i:int =1; i < 4; i++) 
			{
				
				
				var levelItem:LevelItem=new LevelItem(mc_monde.getChildByName("mc_n"+i));
				levelItem.view.btn_start.removeEventListener(MouseEvent.CLICK,onClickLevelItem);
				
			}
			
		}
		protected function onClickPrev(event:MouseEvent):void
		{
			currentIndex--
			goMonde("prev");	
			checkButtons();
			
		}
		
		private function goMonde(dir:String="next"):void
		{
			if(dir=="next"){
				TweenLite.to(mc_monde,0.3,{x:-300,alpha:0 ,ease:Quad.easeOut,onComplete:function(){ mc_monde.x=500; TweenLite.to(mc_monde,0.5,{x:110,alpha:1});  setDataCurrentMonde(); }
					
					});
				
			}else{
				TweenLite.to(mc_monde,0.3,{x:500,alpha:0 ,ease:Quad.easeOut,onComplete:function(){ mc_monde.x=-300; TweenLite.to(mc_monde,0.5,{x:110,alpha:1});  setDataCurrentMonde(); }});
			}
			 
		}
		private function setDataCurrentMonde():void
		{
			if(queue){
				queue.cancel();
			}
			for (var i:int = currentIndex*3; i < currentIndex*3+3; i++) 
			{
			    trace(this+" "+"mc_n"+(i-currentIndex*3+1)+" "+mc_monde.getChildByName("mc_n"+(i-currentIndex*3+1)));
				var levelItem:LevelItem=new LevelItem(mc_monde.getChildByName("mc_n"+(i-currentIndex*3+1)));
				levelItem.setData(levelsData[i]);
				queue.append( new ImageLoader(LevelScore(levelsData[i]).image, {name:"photo"+i, estimatedBytes:2400, container:levelItem.view.mc_image, alpha:1, width:88, height:48, scaleMode:"proportionalInside"}) );
			}
			//start loading
			queue.load();
			mc_monde.mc_black.visible=!(levelsData[currentIndex*3] as LevelScore).active;
			mc_monde.txt_title.text=(levelsData[currentIndex*3] as LevelScore).monde
			while(mc_monde.mc_image.numChildren){
			  mc_monde.mc_image.removeChildAt(0);
			}
			if(loadImage){
				loadImage.cancel();
			}
			loadImage=new ImageLoader("mondes/monde"+(currentIndex+1)+".jpg", {name:"photo", estimatedBytes:2400, container:mc_monde.mc_image, alpha:1, width:570, height:360, scaleMode:"proportionalInside"}) 
			loadImage.load();
		}
		
		private function checkButtons():void
		{
			if( currentIndex < mondes.length-1 ){
				btn_next.mouseEnabled=true;
				btn_next.alpha=1;
			}else{
				btn_next.mouseEnabled=false;
				btn_next.alpha=0.8;
			}
			
			if( currentIndex > 0 ){
				btn_prev.mouseEnabled=true;
				btn_prev.alpha=1;
			}else{
				btn_prev.mouseEnabled=false;
				btn_prev.alpha=0.8;
			}
		}
		
		protected function onClickNExt(event:MouseEvent):void
		{
			currentIndex++
				goMonde();	
			checkButtons();
			
		}
		
		protected function onLoadLevels(event:LoadEvent):void
		{
			trace(this+" onLoadLevels ");
			levelsData=event.load_data as Array
			for (var i:int = 0; i < levelsData.length; i++) 
			{
				trace(this+" levels "+levelsData[i].star_super);
			}
			
			setDataCurrentMonde();
			mc_monde.visible=true;
			btn_next.visible=btn_prev.visible=true;
		}
	}
}