package register.ui
{
	//import caurina.transitions.Tweener;
	import com.greensock.TweenLite;
	import com.greensock.easing.FastEase;
	import com.greensock.easing.Quint;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import register.ui.combo.EComboItem;
	import register.ui.combo.events.EComboEvent;
	import register.ui.scroller.EMouseScroller;
	
	/**
	 * ...
	 * @author Chakir
	 */
	public class ECombo extends MovieClip
	{
		public var btnopen:MovieClip;
		public var txt_choix:TextField;
		public var liste:MovieClip;
		public var masque:MovieClip;
		public var fond:ERectange;
		public var fond_choix:ERectange;
		
		public var data:Array
		
		public static const CLOSED:int = 0;
		public static const OPENED:int = 1;
		
		
		
		public var etat:int = CLOSED;
		
		public var items:Array;
		
		private var _w:int;
		private var _selectedIndex:int = -1;
		private var choixHeight:int = 20;
		private var colors:Array=[0x555555,0xC1C1C1]
		
		public var bublingEvent:Boolean = false;;
		public var liste_container:Sprite;
		
		public var mc_fond:ERectange
		private var round:int;
		
		private var _listeOverture:int = 2;
		private var vSpace:int = 4;
		private var margin:int = 10;
		private var max_item_showed:uint=5;
		private var choixWidth:int;
		private var hasFocus:Boolean=false;

		private var zone_reactive:Sprite;
		private var queue:LoaderMax;
		
		
		public function ECombo(data:Array=null,w:int=80,choix_height:int=21,colors:Array=null,round:int=0,overture:int=2,max:int=13) 
		{
			
			 _listeOverture=overture
			 this.choixHeight = choix_height;
			 this.max_item_showed=max;
			 this._w = w;
			 this.choixWidth = w;
			 this.round = round;
			 this.colors = (colors)?colors:this.colors;
			 
			 
			 masque.height = 0; 
			 masque.alpha=0.2
			 liste.mask = masque;
			
			 txt_choix.autoSize = TextFieldAutoSize.LEFT;
			// txt_choix.mouseEnabled = false;
			// txt_choix.embedFonts = true;
			 txt_choix.textColor=colors[2] || 0x002E5B;
			 //txt_choix.defaultTextFormat = new TextFormat("Calisto MT", 14,null,true,null);
			 
			 zone_reactive=addChildAt(new ERectange(choixWidth,choixHeight,0xDF),2) as Sprite;
			 zone_reactive.alpha=0.0;
			 
			 zone_reactive.addEventListener(MouseEvent.ROLL_OVER, onMOver);
			 zone_reactive.addEventListener(MouseEvent.ROLL_OUT, onMOut);
			 zone_reactive.addEventListener(MouseEvent.CLICK, onMClick,false,1,true);
			 zone_reactive.buttonMode=true;
			 btnopen.curs.gotoAndStop(1);
			 
			
			 btnopen.buttonMode = true;
			 addEventListener(Event.ADDED_TO_STAGE, onAdded);
			 addEventListener(FocusEvent.FOCUS_OUT, onFocusOutHandler);
		  	 addEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
			 if(data)
			 setData(data)
			
			
			
			 
			
		}
		public function setData(data:Array):void{
			 if(data)
			 initListe(data);
			 mc_fond = new ERectange(choixWidth, choixHeight, this.colors[0],this.colors[1],true,null,round,0,0x043E40);
			 mc_fond.addEventListener(MouseEvent.CLICK, onMClick);
			 mc_fond.alpha=0;
			 addChildAt(mc_fond, 0);
			 mc_fond.alpha=1
		}
		
		private function onAdded(e:Event):void 
		{
			trace(this + "  onAdded ");
			stage.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			stage.addEventListener(MouseEvent.CLICK, onClickStage);//,true,0,false);
			
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved)
			 //liste.filters=[new DropShadowFilter(2,90,0x000000,0.9,1,1)];
		}
		
		private function onRemoved(e:Event):void 
		{
			stage.removeEventListener(MouseEvent.CLICK, onClickStage);
		}
		
		private function onClickOut(e:MouseEvent):void 
		{
			trace(this + "onClickOut  Click   "+e.eventPhase+" EventPhase.AT_TARGET "+EventPhase.AT_TARGET+"   ");
		//	if (etat == OPENED && e.target.parent!=this && e.target.parent.parent!=this) {
				//onMClick(null);
			//}
			if (etat == OPENED  && e.eventPhase == EventPhase.AT_TARGET ){
				onMClick(null);
			}
			
		}
		public function close():void{
			if(etat== OPENED){
				onMClick(null);
			}
		}
		public function updateW(w:int) :void{
			masque.width = w+1;
			//liste.fond.height = 6;
		 
			 
			choixWidth=w
				
			zone_reactive.width=w;
			 
			btnopen.x = choixWidth -btnopen.width-2;
			for each(var item:EComboItem in items)
			item.setWidth( w - 2*margin);
		}
		public function initListe(data:Array=null):void {
			this.data=data;
			queue = new LoaderMax({name:"mainQueue", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});
			
			liste_container=new Sprite();
			liste_container.y=4
			liste.addChild(liste_container);
			items = new Array();
			var item:EComboItem;
			var yy:int = 4;
			var max_width:Number=0;
			for (var i:int = 0; i < data.length; i++) {
				item= new EComboItem();
				item.buttonMode = true;
				item.mouseChildren = false;
				item.addEventListener(MouseEvent.CLICK, onItemClick);
				item.addEventListener(MouseEvent.ROLL_OVER, onItemOver);
				item.addEventListener(MouseEvent.ROLL_OUT, onItemOut);
				item.txt_label.text = data[i].label;
				item.id = data[i].id;
				var containerItem:Sprite=new Sprite();
				containerItem.x=containerItem.y=2;
				item.addChild(containerItem);
				trace(this+" data[i].image "+data[i].image);
				if(data[i].image)
				queue.append( new ImageLoader(data[i].image, {name:"photo"+i, estimatedBytes:2400, container:containerItem, alpha:1, width:26, height:26, scaleMode:"proportionalInside",onOpen:function(e:Event){}}) );
				//item.txt_label.textColor=0x000000
				if(colors[2]){
					item.colors[0]=colors[2];
					item.txt_label.textColor=colors[2];
				}
				//item.setColorSelection(data[i].color);
				items.push(item);
				liste_container.addChild(item);
				item.y = int(yy);
				item.x = margin;
				yy = item.y + item.height;
				max_width = Math.max(max_width, item.txt_label.width);
			}
			queue.load();
			item.mc_trait.visible = false;
			max_width = Math.max(_w, max_width+2*margin);
			updateW(max_width);
			
			var h_liste:int = liste.height;
			if ( items.length > max_item_showed ) {
			 
			  var mouseScroller:EMouseScroller = new EMouseScroller(liste_container, item.height * max_item_showed);
			   h_liste = item.height * max_item_showed + 2*vSpace;
			}
			
			
			
			fond = new ERectange(max_width, h_liste + 4,this.colors[0],this.colors[1],true,null,round,0,0x043E40);
			
			fond.alpha = 1;
			masque.width = fond.width + 10;
			 
			 
			
		 	liste.addChildAt(fond, 0);
			if (liste.fond)
			liste.removeChild(liste.fond);
			
			trace(this+" <<<<<<<<<<<<<<>>>>>>>>>>>>>> "+liste.height)
			
			switch(listeOverture) {
				case 0 : liste.y = choixHeight + vSpace ;
				         masque.y = liste.y;
				
				break;
				case 1 :liste.y =  -vSpace-h_liste ;
				         masque.y = -vSpace+2;
				
				
				break;
				case 2 : liste.y = int(-h_liste/2 +choixHeight/2);
				         masque.y = int(choixHeight/2);
				
				
				break;
			}
			
			liste.x = masque.x=0;
			
		}
		
		private function onMOver(e:MouseEvent):void {
		 
		    if(etat!=OPENED)
              TweenLite.to(btnopen.curs,0.5, { y:24, ease:"easeOut"   } );
            else
            TweenLite.to(btnopen.curs,0.5, { y:-9, ease:"easeOut"   } );
            
       
			
		}
		private function onMOut(e:MouseEvent):void {
		 
		    TweenLite.to(btnopen.curs,0.4, { y:8} );
			 
		}
		private function onMClick(e:MouseEvent):void {
			if(etat==CLOSED){
			 
			 openAnimeListe()
			 btnopen.curs.gotoAndStop(2);
			  
			 etat = OPENED
			 setKeyListener();
			}else {
		 
			 closeAnimeListe();
			 btnopen.curs.gotoAndStop(1);
			 
			 etat = CLOSED;
			 removeKeyListener();
			 
			}
			onMOver(null)
		}
		public function closeAnimeListe():void {
			switch(listeOverture) {
				case 0 :  
				     
					TweenLite.to(masque,0.4, {height:0,ease:Quint.easeOut} );
				break;
				case 1 : 
				   
				    TweenLite.to(masque, 0.5,{ height:0 ,y:0 ,ease:Quint.easeOut} );
				
				break;
				case 2 :  
				    
				   TweenLite.to(masque,0.5, { height:0 ,y:int(choixHeight/2),ease:Quint.easeOut} );
				
				break;
			}
		}
		public function openAnimeListe():void {
			switch(listeOverture) {
				case 0 :  
				    //Tweener.addTween(masque, { height:liste.height +4 , transition:"easeOut" , time:0.5 } );
				    TweenLite.to(masque,0.5, { height:liste.height +4  ,ease:Quint.easeOut} );
				break;
				case 1 : 
				    //Tweener.addTween(masque, { height:liste.height +4  ,y:liste.y-1 ,transition:"easeOut" , time:0.5 } );
				    TweenLite.to(masque,0.5, { height:liste.height +4  ,y:liste.y-1 ,ease:Quint.easeOut } );
				
				break;
				case 2 :  
				   //Tweener.addTween(masque, { height:liste.height +4 ,y:liste.y-1, transition:"easeOut" , time:0.5 } );
				   TweenLite.to(masque,0.5, { height:liste.height +4 ,y:liste.y-1,ease:Quint.easeOut  } );
				
				break;
			}
		}
		private function onFocusInHandler(e:FocusEvent):void 
		{
			hasFocus = true;
			trace("onFocusInHandler");
		}
		
		private function onFocusOutHandler(e:FocusEvent):void 
		{
			hasFocus = false;
			trace("onFocusOutHandler");
			//if(etat==OPENED)
			//setTimeout(onMClick,500,null);
			  
		}
		
		private function onClickStage(e:MouseEvent):void 
		{
			trace(e.target + "  " + !hasFocus);
			 
			if (!hasFocus) {
				if (etat == OPENED)
				onMClick(null);
			}
			
		}
		
		private function onItemClick(em:MouseEvent):void {
			var itemselect:EComboItem = em.currentTarget as EComboItem;
		
		   if(data[items.indexOf(itemselect)].image){
			if(getChildByName("photo"))
			removeChild(getChildByName("photo"));
			var containerItem:Sprite=new Sprite();
			containerItem.x=containerItem.y=4;
			containerItem.name="photo";
			addChildAt(containerItem,getChildIndex(liste)-1);
			var imageLoader:ImageLoader=new ImageLoader(data[items.indexOf(itemselect)].image, {name:"photo", estimatedBytes:2400, container:containerItem, alpha:1, width:26, height:26, scaleMode:"proportionalInside",onOpen:function(e:Event){}})
		    imageLoader.load();
		   }
			txt_choix.text = itemselect.txt_label.text//.toUpperCase();
				 
			 var event :EComboEvent = new EComboEvent(EComboEvent.ITEM_SELECTED,bublingEvent);
			 
			 event.item = itemselect;
			 dispatchEvent(event);
			 onMClick(null);
		}
		private function onItemOver(em:MouseEvent):void {
			var itemselect:EComboItem = em.currentTarget as EComboItem;
			selectItem(itemselect);
			selectedIndex=items.indexOf(itemselect);
		     // itemselect.mc_selection.width = liste.width-8;
		}
		private function onItemOut(em:MouseEvent):void {
			var itemselect:EComboItem = em.currentTarget as EComboItem;
			unselectItem(itemselect);
		      //itemselect.mc_selection.width=0;
			  
		}
		private function selectItem(item:EComboItem):void {
			//Tweener.addTween(item.mc_selection, { width:liste.width - 20, transition:"easeOut" , time:0.6 } );
			//item.txt_label.textColor = 0xFFFFFF;
			item.onMOUver(null);
		}
		private function unselectItem(item:EComboItem):void {
			//Tweener.addTween(item.mc_selection, { width:0, transition:"easeOut" , time:0.6 } );
			//item.txt_label.textColor = 0xD3D3D3;
			item.onMOut(null);
		}
		public function setKeyListener():void {
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyDownn);
		}
		public function removeKeyListener():void {
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyDownn);
		
		}
		private function onKeyDownn(ke:KeyboardEvent):void {
			trace("onKeyDown  " + String.fromCharCode(ke.charCode));
			
			if (ke.keyCode == Keyboard.DOWN && selectedIndex < items.length-1) {
				selectItem((items[selectedIndex + 1] as EComboItem))
				if(selectedIndex!=-1)
				unselectItem(items[selectedIndex]);
				selectedIndex++;
				 
			}else if (ke.keyCode == Keyboard.UP && selectedIndex >0) {
				selectItem((items[selectedIndex-1] as EComboItem))
				unselectItem(items[selectedIndex]);
				selectedIndex--;
			}
			else if (ke.keyCode == Keyboard.ENTER && selectedIndex >=0 && selectedIndex < items.length) {
			  txt_choix.text = items[selectedIndex].txt_label.text;//.toUpperCase();
			 var event :EComboEvent = new EComboEvent(EComboEvent.ITEM_SELECTED,bublingEvent);
			 event.item = items[selectedIndex];
			 dispatchEvent(event);
			 onMClick(null);
			}
			
		}
		
		public function get selectedIndex():int { return _selectedIndex; }
		
		public function set selectedIndex(value:int):void 
		{
			_selectedIndex = value;
		}
		
		public function get listeOverture():int { return _listeOverture; }
		
		public function set listeOverture(value:int):void 
		{
			_listeOverture = value;
		}
		
		function progressHandler(event:LoaderEvent):void {
			trace("progress: " + event.target.progress);
		}
		
		function completeHandler(event:LoaderEvent):void {
			//	var image:ContentDisplay = LoaderMax.getContent("photo1");
			//TweenLite.to(image, 1, {alpha:1, y:100});
			trace(event.target + " is complete!");
		}
		
		function errorHandler(event:LoaderEvent):void {
			trace("error occured with " + event.target + ": " + event.text);
		}
		
	}
	
}