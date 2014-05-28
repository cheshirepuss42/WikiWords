package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class AnimatedBackground extends Sprite
	{
		private var td:Number = 10;
		private var direction:int = 1;
		private var reversed:Boolean = false;
		private var flowspeed:Number = 0.5;
		
		public function AnimatedBackground() 
		{
			addEventListener(Event.ENTER_FRAME, step);
		}
		
		private function perspective(d:Number=1):void
		{
			this.graphics.lineStyle(1);
			d *= Math.pow(1.15, 30);
			for (var i:int = 0; i < 30; i++) 
			{
				this.graphics.beginFill((i%2==0)?0x333333:0x222222);
				this.graphics.drawCircle(stage.stageWidth / 2, stage.stageHeight / 2 , d);
				this.graphics.endFill();
				d /= 1.15;
			}
		}
		
		public function step(e:Event):void
		{
			this.graphics.clear(); 
			perspective(td);				
			td += 0.02 * direction * flowspeed;				
			if (td > 13.2) td = 10;
			if (td <10) td = 13.2;
		}
		public function reverse():void
		{
			direction = direction * -1;
		}
	}
	
}