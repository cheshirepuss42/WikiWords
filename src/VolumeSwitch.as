package  
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.*;
	
	public class VolumeSwitch extends Sprite
	{
		private var label:TextField = new TextField();
		private var format:TextFormat = new TextFormat();
		public function VolumeSwitch() 
		{
			format.font = "Arial";
			format.size = 14;	
			format.color = 0xeeeeee;
			label.selectable = false;						
			label.mouseEnabled = false;		
			label.antiAliasType = "advanced";
			addChild(label);			
			setText("turn sound OFF");			
			//label.addEventListener(MouseEvent.CLICK, handleClick);
		}
		private function setText(sc:String):void
		{		
			label.text = sc;
			label.setTextFormat(format);
			label.autoSize = TextFieldAutoSize.LEFT;	
		}	
		public function toggle():void
		{
			if (label.text == "turn sound OFF")
				setText("turn sound ON");
			else
				setText("turn sound OFF");			
		}
	}
}