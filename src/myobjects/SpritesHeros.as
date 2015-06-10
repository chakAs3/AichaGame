package myobjects
{
  
	import com.citrusengine.view.starlingview.AnimationSequence;
	
	import flash.display.Bitmap;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class SpritesHeros
	{
		/* 9fizo SpriteSheet */
		[Embed(source="../embed/spritesheets/sprite_9fizou.xml", mimeType="application/octet-stream")]
		private var _hero9fizoConfig:Class;
		
		[Embed(source="../embed/spritesheets/sprite_9fizou.png")]
		private var _hero9fizoPng:Class;
		
		/* 7chimo SpriteSheet */
		[Embed(source="../embed/spritesheets/sprite_7chimo.xml", mimeType="application/octet-stream")]
		private var _hero7chimoConfig:Class;
		
		[Embed(source="../embed/spritesheets/sprite_7chimo.png")]
		private var _hero7chimoPng:Class;
		
		/* fhimo SpriteSheet */
		[Embed(source="../embed/spritesheets/sprite_fhimo.xml", mimeType="application/octet-stream")]
		private var _herofhimoConfig:Class;
		
		[Embed(source="../embed/spritesheets/sprite_fhimo.png")]
		private var _herofhimoPng:Class;
		
		/* fri7o SpriteSheet */
		[Embed(source="../embed/spritesheets/sprite_fri7o.xml", mimeType="application/octet-stream")]
		private var _herofri7oConfig:Class;
		
		[Embed(source="../embed/spritesheets/sprite_fri7o.png")]
		private var _herofri7oPng:Class;

		/* kricho SpriteSheet */
		[Embed(source="../embed/spritesheets/sprite_kricho.xml", mimeType="application/octet-stream")]
		private var _herokrichoConfig:Class;
		
		[Embed(source="../embed/spritesheets/sprite_kricho.png")]
		private var _herokrichoPng:Class;
		
		/* ksilo SpriteSheet */
		[Embed(source="../embed/spritesheets/sprite_ksilo.xml", mimeType="application/octet-stream")]
		private var _heroksiloConfig:Class;
		
		[Embed(source="../embed/spritesheets/sprite_ksilo.png")]
		private var _heroksiloPng:Class;
		
		/* ngiro SpriteSheet */
		[Embed(source="../embed/spritesheets/sprite_ngiro.xml", mimeType="application/octet-stream")]
		private var _herongiroConfig:Class;
		
		[Embed(source="../embed/spritesheets/sprite_ngiro.png")]
		private var _herongiroPng:Class;
		
		
		/* note1 animation SpriteSheet */
		[Embed(source="../embed/spritesheets/sprite_note1.xml", mimeType="application/octet-stream")]
		private var _note1Config:Class;
		
		[Embed(source="../embed/spritesheets/sprite_note1.png")]
		private var _note1Png:Class;
		
		/* note2 animation SpriteSheet */
		[Embed(source="../embed/spritesheets/sprite_note2.xml", mimeType="application/octet-stream")]
		private var _note2Config:Class;
		
		[Embed(source="../embed/spritesheets/sprite_note2.png")]
		private var _note2Png:Class;
		
		
		/* hero transformation animation SpriteSheet */
		[Embed(source="../embed/spritesheets/transformation.xml", mimeType="application/octet-stream")]
		private var _transConfig:Class;
		
		[Embed(source="../embed/spritesheets/transformation.png")]
		private var _transPng:Class;
	
		
		
		
		
		private var animationsHero:Array;
		
		public var specials:Array;
		
		private var textureAtlas:Array;
		private var animationSequencNote1:AnimationSequence;
		private var animationSequencNote2:AnimationSequence;
		
		private var _objectsPng:Vector.<Class> = new Vector.<Class>();
		private var _objectsConfig:Vector.<Class> = new Vector.<Class>();
		private var _objectsAnimations:Vector.<Array> = new Vector.<Array>();
		private var _currentAnimation:AnimationSequence;
		
		public function SpritesHeros()
		{
			/*les animation Sequences pour les naims */
			
			_objectsPng.push(_hero9fizoPng);
			_objectsPng.push(_hero7chimoPng);
			_objectsPng.push(_herofhimoPng);
			_objectsPng.push(_herofri7oPng);
			_objectsPng.push(_herokrichoPng);
			_objectsPng.push(_heroksiloPng);
			_objectsPng.push(_herongiroPng);
			
			_objectsConfig.push(_hero9fizoConfig);
			_objectsConfig.push(_hero7chimoConfig);
			_objectsConfig.push(_herofhimoConfig);
			_objectsConfig.push(_herofri7oConfig);
			_objectsConfig.push(_herokrichoConfig);
			_objectsConfig.push(_heroksiloConfig);
			_objectsConfig.push(_herongiroConfig);
			
			_objectsAnimations.push(["fall","hurt","idle","jump","walk","die"]);
			_objectsAnimations.push(["fall","hurt","idle","run","walk","die"]);
			_objectsAnimations.push(["fall","hurt","idle","secret","walk","die"]);
			_objectsAnimations.push(["fall","hurt","idle","shoot","walk","die"]);
			_objectsAnimations.push(["fall","hurt","idle","push","walk","die"]);
			_objectsAnimations.push(["fall","hurt","idle","duck","crouch","duckidle","walk","die"]);
			_objectsAnimations.push(["fall","hurt","idle","absorb","walk","die"]);
			 
			//animationSequence9fizo  = new AnimationSequence(createTextureAtlas(new _hero9fizoPng(),new _hero9fizoConfig()), ["fall","hurt","idle","jump","walk"], "idle");
			/*animationSequence7chimo = new AnimationSequence(createTextureAtlas(new _hero7chimoPng(),new _hero7chimoConfig()), ["fall","hurt","idle","run","walk"], "idle");
			animationSequencefhimo  = new AnimationSequence(createTextureAtlas(new _herofhimoPng(),new _herofhimoConfig()), ["fall","hurt","idle","secret","walk"], "idle");
			animationSequencefri7o  = new AnimationSequence(createTextureAtlas(new _herofri7oPng(),new _herofri7oConfig()), ["fall","hurt","idle","shoot","walk"], "idle");
			animationSequencekricho = new AnimationSequence(createTextureAtlas(new _herokrichoPng(),new _herokrichoConfig()), ["fall","hurt","idle","push","walk"], "idle");
			animationSequenceksilo  = new AnimationSequence(createTextureAtlas(new _heroksiloPng(),new _heroksiloConfig()), ["fall","hurt","idle","duck","crouch","duckidle","walk"], "idle");
			animationSequencengiro  = new AnimationSequence(createTextureAtlas(new _herongiroPng(),new _herongiroConfig()) , ["fall","hurt","idle","absorb","walk"], "idle");
			*/
			//animationsHero=[animationSequence9fizo,animationSequence7chimo,animationSequencefhimo,animationSequencefri7o,animationSequencekricho,animationSequenceksilo,animationSequencengiro];
		    specials=["jump","run","secret","shoot","push","duck","absorb","crouch"];
			
			
			//animationSequencNote1  = new AnimationSequence(createTextureAtlas(new _note1Png(),new _note1Config()) , ["normal","exploded"], "normal");
			//animationSequencNote2  = new AnimationSequence(createTextureAtlas(new _note2Png(),new _note2Config()) , ["normal","exploded"], "normal");
		}
		private function createTextureAtlas(bitmap:Bitmap,xml:*):TextureAtlas
		{
			var texture:Texture = Texture.fromBitmap(bitmap);
			var _xml:XML = XML(xml);
			var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, _xml);
			
			return sTextureAtlas
		}
		public function getAnimationSequence(index:int):AnimationSequence
		{
			try{ 
			 _currentAnimation=new AnimationSequence(createTextureAtlas(new _objectsPng[index](),new _objectsConfig[index]()),_objectsAnimations[index],"idle");
			}catch(er:Error){
				trace(this+"getAnimationSequence e$EEEErreur !!!!");
				_currentAnimation=null;
			}
			 return _currentAnimation
		}
		
		public function getAnimationSequenceNote1():AnimationSequence
		{ 
			return new AnimationSequence(createTextureAtlas(new _note1Png(),new _note1Config()) , ["normal","exploded"], "normal");
		}
		
		public function getAnimationSequenceNote2():AnimationSequence
		{
			return new AnimationSequence(createTextureAtlas(new _note2Png(),new _note2Config()) , ["normal","exploded"], "normal");
		}
		public function getAnimationSequenceTransHero():AnimationSequence
		{
			return new AnimationSequence(createTextureAtlas(new _transPng(),new _transConfig()) , ["normal"], "normal");
		}
		public function destroy():void{
			//animationSequence9fizo.destroy();
			//if( _currentAnimation )
			//_currentAnimation.destroy();
			
			if(!_objectsPng || !_objectsConfig ) return ;
			_objectsPng.length = 0;
			_objectsConfig.length = 0;
			_objectsAnimations.length = 0;
			_objectsPng=null;
			_objectsConfig=null
			_objectsAnimations=null
		}
	}
}