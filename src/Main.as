package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageDisplayState;
	import flash.events.KeyboardEvent;	
	
	[SWF(width = "600", height = "450", backgroundColor = "#333333", frameRate = "25")]
	
	public class Main extends Sprite 
	{
		private var game:WikiWordsGame;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var language:String = (this.root.loaderInfo.parameters.hasOwnProperty("language"))?String(this.root.loaderInfo.parameters.language):"en";
			var defaultUrl:String = "http://games.spandrel.nl/wikiwords/wikiwords.php";
			var xmlGenerator:String = (this.root.loaderInfo.parameters.hasOwnProperty("url"))?String(this.root.loaderInfo.parameters.url):defaultUrl;
			game = new WikiWordsGame(stage.stageWidth, stage.stageHeight,xmlGenerator,language);
			addChild(game);
		}
		private function keys(e:KeyboardEvent):void
		{
			if (e.keyCode == 32)
			{
				if (this.stage.displayState == StageDisplayState.NORMAL)
					this.stage.displayState = StageDisplayState.FULL_SCREEN;
				else
					this.stage.displayState = StageDisplayState.NORMAL;
			}
		}		
	}	
}