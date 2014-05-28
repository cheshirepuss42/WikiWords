package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.*;	

	public class LevelPopup extends Sprite
	{
		private var txt:TextField = new TextField();
		private var format:TextFormat = new TextFormat();
		private var w:int;
		private var h:int;
		
		public function LevelPopup(_w:int,_h:int) 
		{
			w = _w;
			h = _h;
			addChild(txt);
			format.color =0xeeeeee;
			format.font = "Arial";
			format.bold = true;
			format.size = 16;
			this.visible = false;
			this.mouseEnabled = false;
			txt.selectable = false;
		}

		public function showPopup(message:String):void
		{
			trace("popup");
			var pad:int = 200;
			this.graphics.clear();
			txt.text = message;
			txt.setTextFormat(format);
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.x = w / 2 - txt.width / 2;
			txt.y = h / 2 - txt.height / 2;
			var padding:int = 20;
			this.graphics.beginFill(0xeeee00);
			this.graphics.drawRoundRect(txt.x-padding, txt.y-padding, txt.width+(padding*2), txt.height+(padding*2),20,20);
			this.graphics.endFill();	
			padding /= 1.5;
			this.graphics.beginFill(0x000033);
			this.graphics.drawRect(txt.x-padding, txt.y-padding, txt.width+(padding*2), txt.height+(padding*2));
			this.graphics.endFill();			
			this.addEventListener(Event.ENTER_FRAME, fadePopup);
			this.visible = true;			
		}	
		private function fadePopup(e:Event):void
		{
			if (this.alpha < 0.1)
			{
				this.alpha = 1;
				this.visible = false;
				this.removeEventListener(Event.ENTER_FRAME, fadePopup);
				
			}
			else
			{
				this.alpha *= 0.94;
			}
		}
	}
	
}