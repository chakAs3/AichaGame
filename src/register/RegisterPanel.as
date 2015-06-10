package register
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	
	import myobjects.model.GameModel;
	
	import register.events.RegisterEvent;
	import register.manager.FaceBookGraph;
	import register.ui.ECombo;
	import register.ui.combo.events.EComboEvent;
	import register.ui.form.ErrorPuceForm;
	import register.utils.EmailValidator;
	import register.xml.RegisterFormSend;
	
	public class RegisterPanel extends Sprite
	{
		
		public var titre:String = "formulaire d'information";
		
		public var txt_last_name:TextField;
		public var txt_first_name:TextField;
		public var txt_email:TextField;
		public var txt_tel:TextField;
		public var txt_cin:TextField;
		public var txt_addresse:TextField;
		
		
		public var mc_error_last_name:ErrorPuceForm;
		public var mc_error_first_name:ErrorPuceForm;
		public var mc_error_email:ErrorPuceForm;
		public var mc_error_tel:ErrorPuceForm;
		public var mc_error_cin:ErrorPuceForm;
		public var mc_error_equipe:ErrorPuceForm;
		public var mc_error_upload:ErrorPuceForm;
		
		public var mc_error_date:ErrorPuceForm;
		public var mc_error_ville:ErrorPuceForm;
		public var mc_error_village:ErrorPuceForm;
		
		public var txt_label_cin:TextField;
		
		public var mc_check:*//ECheckBox;
		
		public var txt_error:TextField
		
		private var elementsToValidate:Array;
		
		
		private var errorEmail:String="adresse email invalide ";
		private var errorEmptyFields:String = "champs obligatoires ";
		
		
		
		public var date_container:Sprite;
		public var ojectRequest:Object;
		private var dataJour:Array;
		private var dataAns:Array;
		private var dataMonth:Array;
		private var jourCombo:ECombo;
		private var moisCombo:ECombo;
		private var ansCombo:ECombo;
		
		public var btn_reglement:SimpleButton;
		
		public var btn_send:SimpleButton;
		public var btn_close:SimpleButton;
		//private var mc_regement:ReglementPanel;
		
		public var villeCombo:ECombo;
		
		private var villageCombo:ECombo;
		
		
		public var txt_file:TextField;
		public var mc_bar_progression:MovieClip;
		public var btn_browse:MovieClip;
		
		public var refUpload:String;
	 
		public var valideUpload:Boolean = false;
		private var equipeCombo:ECombo;
		
		public var mc_container_villes:Sprite;
		
		public var mc_date_j:Sprite;
		public var mc_date_m:Sprite;
		public var mc_date_a:Sprite;
		public function RegisterPanel()
		{
			super();
			txt_last_name.embedFonts = true;
			txt_first_name.embedFonts = true;
			txt_email.embedFonts = true;
			txt_tel.embedFonts = true;
			 
			txt_error.embedFonts = true;
			// txt_cin.embedFonts = true;
			// txt_addresse.embedFonts = true;
			
			// txt_label_cin.embedFonts = true;
			// txt_label_cin.selectable = false;
			 
			
			txt_last_name.tabIndex = 0;
			txt_first_name.tabIndex = 1;
			txt_email.tabIndex = 2;
			txt_tel.tabIndex = 3;
			// txt_cin.tabIndex = 4;
			//txt_addresse.tabIndex = 5;
			
			
			txt_tel.restrict = "[0-9]";
			txt_tel.maxChars=10;
			//	 txt_cin.restrict = "A-Z 0-9";
			
			
			
			//.visible = false;
			
			elementsToValidate=new Array();
			elementsToValidate.push( { element:txt_email, validator:"email" ,mc_error:mc_error_email} )
			elementsToValidate.push( { element:txt_last_name, validator:"empty" ,mc_error:mc_error_last_name} )
			elementsToValidate.push( { element:txt_first_name, validator:"empty" ,mc_error:mc_error_first_name} )	
			//	elementsToValidate.push( { element:txt_cin, validator:"empty" ,mc_error:mc_error_cin} )
			 
			//elementsToValidate.push( { element:txt_file, validator:"empty" ,mc_error:mc_error_upload} );
			elementsToValidate.push( { element:txt_tel, validator:"empty" ,mc_error:mc_error_tel} )
			//
			for (var i:int = 0; i < elementsToValidate.length ; i++) { 
				
				elementsToValidate[i].element.addEventListener(FocusEvent.FOCUS_IN,onFocusTextFields)
				
				
			}
			
			btn_send.addEventListener(MouseEvent.CLICK, onCLickSendBTn) ;
			btn_close.addEventListener(MouseEvent.CLICK,onClickClose); 
			//addChild(date_container);
			 
			
			dataJour = new Array();
			for (var i:int = 1; i <= 31 ; i++) {
				dataJour.push( { id:i, label:i+"" } );
			}
			dataMonth = new Array();
			dataMonth.push( { id:1, label:"01" } );
			dataMonth.push( { id:2, label:"02" } );
			dataMonth.push( { id:3, label:"03" } );
			dataMonth.push( { id:4, label:"04" } );
			dataMonth.push( { id:5, label:"05" } );
			dataMonth.push( { id:6, label:"06" } );
			dataMonth.push( { id:7, label:"07" } );
			dataMonth.push( { id:8, label:"08" } );
			dataMonth.push( { id:9, label:"09" } );
			dataMonth.push( { id:10, label:"10" } );
			dataMonth.push( { id:11, label:"11" } );
			dataMonth.push( { id:12, label:"12" } );
			
			dataAns = new Array();
			for (var _i:int = 1950; _i < 2008 ; _i++) {
				dataAns.push( { id:_i, label:_i+"" } );
			}
			
			
			jourCombo = new ECombo(dataJour, 82,40,[0xFFFFFF,0xFFFFFF],40);
			jourCombo.txt_choix.text = "jj";
			jourCombo.addEventListener(EComboEvent.ITEM_SELECTED,onComboDate)
			//date_container.addChild(jourCombo);
			mc_date_j.addChild(jourCombo);
			//jourCombo.filters = [new DropShadowFilter(1, 90, 0, 0.3, 2, 2,1,1,true)];	
			
			moisCombo = new ECombo(dataMonth, 82,40,[0xFFFFFF,0xFFFFFF],40);
			moisCombo.txt_choix.text = "mm";
			//date_container.addChild(moisCombo);
			moisCombo.addEventListener(EComboEvent.ITEM_SELECTED,onComboDate)
			//moisCombo.x = jourCombo.width - 2 -30;
			//	moisCombo.filters = [new DropShadowFilter(1, 90, 0, 0.3, 2, 2,1,1,true)];	
		    mc_date_m.addChild(moisCombo);	
			
			ansCombo = new ECombo(dataAns, 107,40,[0xFFFFFF,0xFFFFFF],40);
			ansCombo.txt_choix.text = "aa";
			//date_container.addChild(ansCombo);
			ansCombo.addEventListener(EComboEvent.ITEM_SELECTED,onComboDate)
			//ansCombo.x =moisCombo.x+ moisCombo.width-2-6 +10;
			mc_date_a.addChild(ansCombo);	
			// ansCombo.filters = [new DropShadowFilter(1, 90, 0, 0.3, 2, 2,1,1,true)];	
			
			
			
			var dataVilles:Array = CModel.villeList//
			/*dataVilles.push( { id:"Casablanca", label:"Casablanca" } );
			dataVilles.push( { id:"Rabat", label:"Rabat" } );
			dataVilles.push( { id:"Salé", label:"Salé" } );
			dataVilles.push( { id:"Tanger", label:"Tanger" } );
			dataVilles.push( { id:"Agadir", label:"Agadir" } );
			dataVilles.push( { id:"Ouajda", label:"Ouajda" } );
			dataVilles.push( { id:"Tetouan", label:"Tetouan" } );
			dataVilles.push( { id:"Jadida", label:"Jadida" } );*/
			

			
			villeCombo = new ECombo(dataVilles, mc_container_villes.width,mc_container_villes.height,[0xFFFFFF,0xFFFFFF],40,0,7);
			villeCombo.txt_choix.text = "Votre Ville";
			mc_container_villes.addChild(villeCombo);
			villeCombo.addEventListener(EComboEvent.ITEM_SELECTED,onComboVilleChanged)
			
			
			
			
			 
			elementsToValidate.push( { element:villeCombo, validator:"list" ,mc_error:mc_error_ville} );
			 
			resetForm();
			
			btn_reglement.addEventListener(MouseEvent.CLICK,onClickREgementPanel);
			if(FaceBookGraph.userInfo){
				setInfoFromFaceObjet(FaceBookGraph.userInfo);
				GameModel.userInfo=FaceBookGraph.userInfo ;
			}
		}
		
		protected function onClickClose(event:MouseEvent):void
		{
			dispatchEvent(new RegisterEvent(RegisterEvent.CHANGE_PAGE,0));
			
		}
		
		protected function onClickREgementPanel(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
		}
		
		protected function onComboVilleChanged(event:Event):void
		{
			TweenLite.to(mc_error_ville, 0.5, { alpha:0} );
		} 
		
		public function setInfoFromFaceObjet(object:Object):void{
			txt_last_name.text=object.last_name || "";
			txt_first_name.text=object.first_name || "";
			txt_email.text=object.email || "";
		}
		
		private function onFocusTextFields(e:FocusEvent):void 
		{
		 
			for (var i:int = 0; i < elementsToValidate.length ; i++) { 
				if(elementsToValidate[i].element == e.currentTarget)  
					TweenLite.to(elementsToValidate[i].mc_error, 0.5, { alpha:0 } );
			}
			
			
		}
		private function onCLickSendBTn(e:MouseEvent):void 
		{
			validateForm();
		}
		private function onCLickResetBTn(e:MouseEvent):void 
		{
			resetForm();
		}
		public function validateForm():void{
			var error:Array=new Array();
			ExternalInterface.call("console.log","validateForm");
			//sendForm();
			//var flechAlert:FlechAlert;
			for (var i:int=0;i< elementsToValidate.length ; i++){
				trace(" elemet "+i+" >"+elementsToValidate[i].element)
				switch(elementsToValidate[i].validator){
					case "empty": 
						var empty:Boolean=((elementsToValidate[i].element as TextField).text=="");
						//( elementsToValidate[i].element as ETextForm).showFlechError(empty);
						//TweenMax.to(arrayIcones[i], 0.5, { tint:0xFF0000 } );
						
						if (empty) { 
							TweenLite.to(elementsToValidate[i].mc_error, 0.5, { alpha:1 } );
							
							error.push("Empty champ"); 
							(elementsToValidate[i].mc_error as ErrorPuceForm).setText("Champ obligatoire");
						}
						break;
					
					case "email": 
						var valide:Boolean=EmailValidator.isValidEmail((elementsToValidate[i].element as TextField).text) ;
						if (! valide ) {
							error.push("The email adress is not valid.");
							TweenLite.to(elementsToValidate[i].mc_error, 0.5, { alpha:1 } );
							(elementsToValidate[i].mc_error as ErrorPuceForm).setText("adresse email invalide");
							trace("email invalide "); 
						}
						//( elementsToValidate[i].element as ETextForm).showFlechError(!valide);
						; break;
					case "emails": 
						var valide:Boolean=EmailValidator.isValidEmailList((elementsToValidate[i].element as TextField).text) ;
						if (! valide ) {
							error.push("The email adress is not valid.");
							TweenLite.to(elementsToValidate[i].mc_error, 0.5, { alpha:1 } );
							trace("email invalide "); 
						}
						//( elementsToValidate[i].element as ETextForm).showFlechError(!valide);
						; break;
					case "list": 
						var noselect:Boolean=((elementsToValidate[i].element as ECombo).selectedIndex==-1) ;
						if ( noselect ) {
							error.push("choisi un élement");
							TweenLite.to(elementsToValidate[i].mc_error, 0.5, { alpha:1 } );
							(elementsToValidate[i].mc_error as ErrorPuceForm).setText("choisi un element ");
							trace("no element choisi ");  
						}
						//( elementsToValidate[i].element as ETextForm).showFlechError(!valide);
						; break;
					default : break;
				}
			}
			/**************************/
			var mois:int = moisCombo.selectedIndex;
			var date_n:Date=new Date(ansCombo.txt_choix.text, mois+1, jourCombo.txt_choix.text);
			date_n.date = Number(jourCombo.txt_choix.text);
			var nbr_jour:Number = new Date(ansCombo.txt_choix.text, mois+ 1, 0).getDate() as Number;
			
			trace(this +mois+ " DATE :  date_n.date nbr_jour:" + nbr_jour + ",jourCombo.txt_choix :  " + jourCombo.txt_choix.text);
			
			/*****************************/
			if (nbr_jour < Number( jourCombo.txt_choix.text)) {
				error.push("Empty champ");
				txt_error.text = "Date de naissance invalide";
				trace(this + " Invalide Date ");
				TweenLite.to(mc_error_date, 0.5, { alpha:1 } );
				(mc_error_date as ErrorPuceForm).setText("Date de naissance invalide");
			}
			if (jourCombo.txt_choix.text.toUpperCase() == "JJ" ||  moisCombo.txt_choix.text.toUpperCase() == "MM" || ansCombo.txt_choix.text.toUpperCase() =="AA") {
				error.push("Empty champ");
				txt_error.text = "Saisissez vote date de naissance";
				TweenLite.to(mc_error_date, 0.5, { alpha:1 } );
				(mc_error_date as ErrorPuceForm).setText("Date de naissance obligatoire");
			}
			
			if (error.length) {
				
				txt_error.htmlText =( (error.indexOf("The email adress is not valid.")>-1)?errorEmail:"" )+( (error.indexOf("Empty champ")>-1)?errorEmptyFields:"" );
				if (error.length == elementsToValidate.length)
					
					//txt_error.htmlText =errorAllField//"All fields are mandatory"
					txt_error.textColor = 0xCC0000 ;
				
			}else{
				txt_error.htmlText =""//errorAllField//"All fields are mandatory";
				 
				if (!mc_check.selected){
					txt_error.text="accepte les termes et les conditions"
					return;
				}
				 
				txt_error.htmlText =""
				sendForm();
				//resetForm()
				
			}
			 
			
		}
		
		private function resetForm():void
		{
			for (var i:int = 0; i < elementsToValidate.length ; i++) { 
				if( elementsToValidate[i].element is TextField)
					elementsToValidate[i].element.text = "";
				if(elementsToValidate[i].mc_error)
					TweenLite.to(elementsToValidate[i].mc_error, 0.5, { alpha:0 } );
			}
			TweenLite.to(mc_error_date, 0.5, { alpha:0 } );
			txt_error.text = "";
			
			
		}
		
		public function sendForm():void {
			
			var idville:String=villeCombo.data[villeCombo.selectedIndex].id;
			if(!FaceBookGraph.userInfo)
			FaceBookGraph.userInfo=new Object();
		//	ExternalInterface.call("console.log","  SEND FORM _ ");	 
			ojectRequest = {userId:FaceBookGraph.userInfo.id, email:txt_email.text,nom:txt_last_name.text ,tel:txt_tel.text,ville:idville,/*village:idvillage,*/date:jourCombo.txt_choix.text+"/"+(moisCombo.selectedIndex+1)+"/"+ansCombo.txt_choix.text,prenom:txt_first_name.text,sex:FaceBookGraph.userInfo.gender,locale:FaceBookGraph.userInfo.locale};
			var send:RegisterFormSend = new RegisterFormSend(ojectRequest);
			send.addEventListener(RegisterEvent.LOAD_REGISTER, onResponseSendRegister);
			//ExternalInterface.call("console.log","  SEND FORM _ 2");	 
			
			//dispatchValidateForm(ojectRequest);
		}
		
		private function onResponseSendRegister(e:RegisterEvent):void 
		{
			txt_error.text=e.load_data.message;
			trace(this+" "+e.load_data.message);
			ExternalInterface.call("console.log","  ___onResponseSendRegister --"+e.load_data.suces+" ---- ");
			if(e.load_data.suces) {
				dispatchEvent(new Event("RegisterDone",true));
			}
		}
		
		private function onComboDate(e:EComboEvent):void 
		{
			if (jourCombo.txt_choix.text == "JJ" ||  moisCombo.txt_choix.text == "MM" || ansCombo.txt_choix.text =="AA") {
				
			}else {
				//var date_n:Date = new Date(ansCombo.txt_choix.text, mois + 1, jourCombo.txt_choix.text);
				if (Number(ansCombo.txt_choix.text) > 1992 ) {
					// txt_label_cin.text = "N° CIN du tuteur ou resp. légal";
				}else {
					// txt_label_cin.text = "N° CIN";
				}
				TweenLite.to(mc_error_date, 0.5, { alpha:0} );
			}
		}
	}
}