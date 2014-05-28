package  
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	public class HelpView extends Sprite
	{
		//heeft button en panel-view
		//beide zijn klikbaar, on top, activeren elkaar en dispatch an event on click
		//
		private var txt:TextField = new TextField();
		private var format:TextFormat = new TextFormat();
		private var showingPanel:Boolean = false;
		private var w:int;
		private var h:int;
		private var helpText:String;
		private var buttonText:String= "show help";
		
		public function HelpView(_helpText:String,_w:int,_h:int)
		{
			addChild(txt);
			helpText = _helpText;
			w = _w;
			h = _h;			
			format.font = "Arial";
			format.color = 0xeeeeee;
			format.align = "center";
			txt.selectable = false;
			txt.multiline = true;
			addEventListener(MouseEvent.CLICK, clicked);
			showButton();
			
		}
		private function clicked(e:MouseEvent):void
		{
			dispatchEvent(new Event("pauseToggle"));
			if (showingPanel)
			{
				showButton();
			}
			else
			{
				showPanel();
			}
		}
		private function showPanel():void
		{
			showingPanel = true;
			var pad:int = 200;
			this.graphics.clear();
			this.graphics.beginFill(0xaaaaff, 0.7);
			this.graphics.drawRect( -pad, -pad, w + (pad * 2), h + (pad * 2));
			this.graphics.endFill();
			txt.text = helpText;
			txt.setTextFormat(format);
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.x = w / 2 - txt.width / 2;
			txt.y = h / 2 - txt.height / 2;
			var padding:int = 20;
			this.graphics.beginFill(0xaaaaff);
			this.graphics.drawRect(txt.x-padding, txt.y-padding, txt.width+(padding*2), txt.height+(padding*2));
			this.graphics.endFill();	
			padding /= 1.5;
			this.graphics.beginFill(0x000033);
			this.graphics.drawRect(txt.x-padding, txt.y-padding, txt.width+(padding*2), txt.height+(padding*2));
			this.graphics.endFill();			
		}
		private function showButton():void
		{
			this.graphics.clear();
			showingPanel = false;
			txt.text = buttonText;
			txt.setTextFormat(format);
			txt.autoSize = TextFieldAutoSize.LEFT;			
			txt.y = h - txt.height;
			txt.x = w - txt.width;
		}
		
		
	}
	
}