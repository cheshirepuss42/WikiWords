package  
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.*;
	
	/**
	 * ...
	 * @author 
	 */
	public class FillBar extends Sprite
	{
		public var filled:Number = 0;
		private var barWidth:Number = 150;
		private var barHeight:Number = 10;
		private var padding:Number = 3;
		private var totalFrames:int;
		private var maxBonus:int;
		private var bonus:TextField = new TextField();
		private var format:TextFormat = new TextFormat();
		private var prefix:String = "Bonus: ";
		public function FillBar(tf:int,_maxBonus:int) 
		{
			totalFrames = tf;
			maxBonus = _maxBonus;
			draw();
			this.alpha = 0.6;
			this.mouseEnabled = false;
			bonus.filters = [new GlowFilter(0xeeeeee)];
			addChild(bonus);
			format.color =0;
			format.font = "Arial";
			//format.color = 0;
			format.bold = true;
			format.size = 9;
			bonus.text = prefix+String(maxBonus);
			bonus.selectable = false;			
			bonus.setTextFormat(format);
			bonus.x += (this.width / 2)-bonus.width/2;
		}
		public function setTotalFrames(tf:int):void
		{
			totalFrames = tf;
		}
		private function draw():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect( 0, 0, barWidth + (padding * 2), barHeight + (padding * 2));
			this.graphics.endFill();
			this.graphics.lineStyle(1);
			this.graphics.drawRect( padding, padding, barWidth , barHeight );
			this.graphics.beginFill(0xffff00);
			this.graphics.drawRect( padding+(barWidth*filled), padding, barWidth-(barWidth*filled) , barHeight );
			this.graphics.endFill();	

			bonus.setTextFormat(format);
			bonus.autoSize = TextFieldAutoSize.LEFT;			
		}
		
		public function step():void
		{			
			filled += (1/totalFrames);
			bonus.text = prefix+String(int(maxBonus-(maxBonus*filled)));
			draw();
		}
		
		public function reset():void
		{
			bonus.text = prefix+String(maxBonus);
			filled = 0;
			draw();
		}
		
	}
	
}