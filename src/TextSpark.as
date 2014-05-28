package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.*;	
	/**
	 * ...
	 * @author 
	 */
	public class TextSpark extends Sprite
	{
		private var frameNr:int = 0;
		private var amFrames:int = 30;
		private var tf:TextField = new TextField();
		private var format:TextFormat = new TextFormat();
		
		public function TextSpark() 
		{
			filters = [new GlowFilter(0)];
			this.visible = false;
			this.mouseEnabled = false;
			format.font = "Arial";
			format.color = 0xeeee22;
			format.align = "center";
			format.size = 15;
			tf.selectable = false;			
			addChild(tf);
			tf.setTextFormat(format);				
		}
		public function spark(_txt:String,col:uint=0xeeee22):void
		{
			tf.y = -30;
			format.color = col;
			this.visible = true;
			frameNr = 0;
			tf.text = _txt;
			tf.setTextFormat(format);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.x = tf.width / -2;	
			this.addEventListener(Event.ENTER_FRAME, sparkAnim);
		}
		private function sparkAnim(e:Event):void
		{
			if (frameNr > amFrames)
			{
				frameNr = 0;
				this.removeEventListener(Event.ENTER_FRAME, sparkAnim);
				this.visible = false;
				tf.x = 0;
			}
			else
			{
				tf.y -= (20 / amFrames);
				frameNr++;	
			}
			
			
		}
		
	}
	
}