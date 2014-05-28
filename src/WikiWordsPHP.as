package  
{
	import flash.events.*;	
	import flash.net.*;	

	public class WikiWordsPHP extends EventDispatcher
	{
		private var results:*;
		private var lan:String;

		public function WikiWordsPHP(url:String,lang:String,seed:String,amRelated:int,amRandom:int) 
		{
			lan = lang;
			var dataFeed:String = "?seed=" + seed + "&related=" + amRelated + "&random=" + amRandom + "&language=" + lan;
			var request:URLRequest = new URLRequest(url+dataFeed);
			var loader:URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			loader.load(request);			
		}
		private function handleIOError(evt:IOErrorEvent):void
		{
			trace(evt);		//handle error if needed
		}		
		public function onComplete(event:Event):void
		{
			var result:XML = new XML(event.target.data);
			var ran:Vector.<String> = new Vector.<String>();
			var rel:Vector.<String> = new Vector.<String>();
			var tempstr:String = "";			
			for (var i:int = 0; i < result.related.length(); i++) 
			{

				rel.push(splitString(result.related[i].text()));				
			}
			for (i = 0; i < result.random.length(); i++) 
			{
				ran.push(splitString(result.random[i].text()));		
			}
			results = { seed:splitString(result.seed.text()), related:rel, random:ran };
			dispatchEvent(new Event(Event.COMPLETE));				
		}
		
		private function splitString(str:String):String
		{
			var temppos:int = int(str.length / 2);
			var stringsplit:int = 8;
			var inserted:Boolean = false;
			if (temppos > stringsplit)
			{					
				var words:Array = str.split(" ");
				str = "";				
				while (words.length > 0)
				{
					str += words.shift() + " ";					
					if (str.length >= temppos && !inserted)
					{
						inserted = true;
						str += "\n";
					}
				}				
			}
			return str;
		}
		public function getResults():*
		{
			return results;			
		}	
		public function openPage(str:String):void
		{
			navigateToURL(new URLRequest("http://"+lan+".wikipedia.org/wiki/"+str));			
		}		
	}
	
}