package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.*;	
	
	/**
	 * ...
	 * @author 
	 */
	public class Satellite extends Sprite
	{
		public var content:String;
		//public var isRandom:Boolean;
		public var isDead:Boolean = false;
		public var type:String;
		private var tf:TextField = new TextField();
		private var format:TextFormat = new TextFormat();
		private var spark:TextSpark = new TextSpark();
		public function Satellite(str:String,_type:String= "seed") 
		{
			type = _type;

			content = str;
			
			format.font = "Arial";
			format.size = (type=="seed")?90/Math.sqrt(content.length):60/Math.sqrt(content.length);	
			format.color = 0xeeeeee;
			format.align = "center";
		
			
			tf.selectable = false;
			tf.text = content; 
			tf.setTextFormat(format);
			tf.mouseEnabled = false;
			tf.multiline = true;
			tf.autoSize = TextFieldAutoSize.LEFT;
			
			tf.antiAliasType = "advanced";
			addChild(tf);
			addChild(spark);
			drawBubble();

		}

		
		private function drawBubble():void
		{
			var padding:int = int(tf.height * 0.4);
			tf.x -= tf.width / 2;
			tf.y -= tf.height / 2;			
			this.graphics.lineStyle(3);
			this.graphics.beginFill(0x2222dd);
			this.graphics.drawEllipse( tf.x - padding, tf.y - padding, tf.width + (padding * 2), tf.height + (padding * 2));
			this.graphics.endFill();			
		}
		
		public function startDeathAnim(sparkVal:int):void
		{
			spark.spark("+"+String(sparkVal));
			isDead = true;
			addEventListener(Event.ENTER_FRAME, deathAnimStep);			
		}
		private function deathAnimStep(e:Event):void
		{
			if (this.alpha > 0 )
			{
				this.alpha -= 0.025;
				this.x += -1 + Math.random() * 2;
				this.y += -1 + Math.random() * 2;
				//this.scaleX *= 0.97;
				//this.scaleY *= 0.97;
			}	
			else
				removeEventListener(Event.ENTER_FRAME, deathAnimStep);
		}
		public function startWrongAnim(sparkVal:int):void
		{
			this.mouseEnabled = false;
			this.scaleX *= 1.3;
			this.scaleY *= 1.3;
			spark.spark("-"+String(sparkVal),0xff2222);
			addEventListener(Event.ENTER_FRAME, wrongAnimStep);		
		}
		private function wrongAnimStep(e:Event):void
		{
			if (this.scaleY > 1 )
			{
				this.scaleX *= 0.975;
				this.scaleY *= 0.975;
			}	
			else
			{
				this.mouseEnabled = true;				
				removeEventListener(Event.ENTER_FRAME, wrongAnimStep);
			}
		}
		public function moveTo(_x:Number, _y:Number):void
		{
			this.x = _x;
			this.y = _y;			
		}
		
	}
	
}