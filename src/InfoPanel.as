package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.text.*;	

	//show score
	//update score with cheeky animation
	//at end of round, show data
	//updateScore(score:int)
	public class InfoPanel extends Sprite
	{
		private var scoreText:TextField = new TextField();
		private var subText:TextField= new TextField();
		private var scoreFormat:TextFormat = new TextFormat();
		private var subFormat:TextFormat = new TextFormat();
		private var frameCounter:int = 0;
		private var tempHeight:Number;
		private var totalHeight:Number;
		public function InfoPanel() 
		{	
			filters = [new GlowFilter(0xffff00,0.3,12,12,3)];
			scoreFormat.font = subFormat.font = "Arial";
			//scoreFormat.font = "Arial";
			scoreFormat.size = 23;
			subFormat.size = 15;
			subText.selectable = false;
			scoreText.selectable = false;
			updateScore(0);
			addChild(scoreText);
			addChild(subText);
			subText.visible = false;
			
		}		
		public function updateScore(score:int):void
		{
			
			scoreText.text = "Score: " + String(score);
			scoreText.setTextFormat(scoreFormat);
			scoreText.autoSize = TextFieldAutoSize.LEFT;
			subText.visible = false;
			drawBackground();
			
		}
		public function showData(score:int,data:String):void
		{
			scoreText.text = "Score: " + String(score);
			scoreText.setTextFormat(scoreFormat);
			scoreText.autoSize = TextFieldAutoSize.LEFT;			
			subText.visible = true;
			subText.y = scoreText.height;
			subText.text = data;
			subText.setTextFormat(subFormat);
			subText.autoSize = TextFieldAutoSize.LEFT;
			drawBackground();
		}
		private function drawBackground(tempheight:Number=0):void
		{
			var padding:int = 3;
			this.graphics.clear();
			this.graphics.beginFill(0xdddd33, 0.8);
			var w:int = (subText.visible)? subText.width:scoreText.width;
			var h:int = (subText.visible)? (scoreText.height + subText.height):scoreText.height;
			this.graphics.drawRect(0, 0, padding+w,padding+h);
			this.graphics.endFill();			
		}	
		/*
		public function setText2(sc:String,showAnim:Boolean=true):void
		{		
			mainText.text = sc;
			mainText.setTextFormat(format);
			mainText.autoSize = TextFieldAutoSize.LEFT;	
			drawBackground();
			if (showAnim)
				startAnimation();
		}	
		public function showSubText2(st:String):void
		{
			format.size = 10;
			subText.y += mainText.height;
			subText.text = st;
			subText.setTextFormat(format);
			subText.autoSize = TextFieldAutoSize.LEFT;		
			format.size = 23;
		}
		public function startAnimation():void
		{
			addEventListener(Event.ENTER_FRAME, animate);
			tempHeight = mainText.height;
			mainText.visible = false;
		}

		private function animate(e:Event):void
		{
			if (frameCounter<5 )
			{
				drawBackground(tempHeight);			
				tempHeight -= mainText.height * 0.24;
				frameCounter++;
			}	
			else
			{
				frameCounter = 0;
				drawBackground();
				mainText.visible = true;
				removeEventListener(Event.ENTER_FRAME, animate);
			}
		}
*/
	}	
}