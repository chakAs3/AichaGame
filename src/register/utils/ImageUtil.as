package emagin.utils 
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author ©haki®
	 */
	public class ImageUtil 
	{
		
		public function ImageUtil() 
		{
			
		}
		public static function getRadio(oWidth:Number, oHeight:Number,nWidth:Number, nHeight:Number,ratioAll:Boolean=false ,isFull:Boolean=false):Number {
		   var ratio:Number=1;
		     var coefw:Number = nWidth/oWidth;
			 var coefh:Number = nHeight/oHeight;		
		   if ( Number(oHeight * coefw > nHeight)) {
				ratio=coefh;
			} else {
				ratio=coefw;			
			}
			if(isFull) return Math.max(coefh,coefw);
			return (ratio<1 || ratioAll) ? ratio:1;
		}
	 
	   public static function resampleBitmapData (bmp:BitmapData, ratio:Number):BitmapData {
	      if (ratio >= 1) {
		     return ( resizeBitmapData(bmp, ratio));
        	}
	           else {
		    var bmpData:BitmapData = bmp.clone();
		    var appliedRatio:Number = 1;
		
		    do {
		  	if (ratio < 0.5 * appliedRatio) {
				 bmpData =  resizeBitmapData(bmpData, 0.5);
				 appliedRatio = 0.5 * appliedRatio;
			  }
			else {
				bmpData =  resizeBitmapData(bmpData, ratio / appliedRatio);
				appliedRatio = ratio;
			}
		   } while (appliedRatio != ratio);
		
		  return (bmpData);
	     }
       }
	   
	   public static function resizeBitmapData (bmp:BitmapData, ratio:Number):BitmapData {
	     var bmpData:BitmapData = new BitmapData(Math.round(bmp.width * ratio), Math.round(bmp.height * ratio),true,0x00000000);
	     var scaleMatrix:Matrix = new Matrix(bmpData.width / bmp.width, 0, 0, bmpData.height / bmp.height, 0, 0);
	     var colorTransform:ColorTransform = new ColorTransform();
	      bmpData.draw(bmp, scaleMatrix, colorTransform, null, null, true);
			
	     return (bmpData);
       }
		
	}
	
}