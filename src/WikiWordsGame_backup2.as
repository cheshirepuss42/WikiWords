package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;

	/* x seconden per ronde
	 * framerate van y
	 * beginafstand a1, eindafstand a2
	 * a3 =a1-a2;
	 * aantal frames in totaal= x*y=z
	 * 
	 * afstand per frame=a3/z;
	 * 
	 *
	 * 
	 * 
	 * 
	 */
	public class WikiWordsGame extends Sprite
	{
		
		
		private var timer:Timer;
		private var speed:Number = 1;
		private var frameRate:Number = speed * 30;
		private var totalTime:Number = 30000;
		private var currentTime:Number;
		private var settings2:*= { startDistance:220, minDistance:90, speed:0.2 };
		
		
		
		private var background:AnimatedBackground= new AnimatedBackground();
		private var satelliteContainer:Sprite = new Sprite();
		private var scoreBox:InfoPanel = new InfoPanel("Score: 0");	
		private var volumeSwitch:VolumeSwitch= new VolumeSwitch();	
		private var seed:Satellite;
		private var randomSatellites:Vector.<Satellite> = new Vector.<Satellite>();
		private var relatedSatellites:Vector.<Satellite> = new Vector.<Satellite>();
		private var angles:Vector.<*>;
		private var center:*;
		private var settings:*= { startDistance:220, minDistance:90, speed:0.2 };
		private var currentDistance:Number;
		private var roundOver:Boolean = false;
		private var helpText:String = "\nClick here for next round\nClick word for related Wikipedia-page";
		private var helpTextnl:String = "\nKlik hier voor de volgende ronde\nKlik woord voor Wikipedia-pagina";
		private var wordCollector:WikiWordsPHP;
		private var w:int;
		private var h:int;
		private var randomWordsLeftInRound:int;
		private var totalScore:int = 0;
		private var roundScore:int = 0;
		private var language:String;
		private var sounds:SoundManager = new SoundManager();
		private var help:HelpView;
		private var paused:Boolean = false;
		private var numRounds:int = 1;
		private var timerBar:FillBar = new FillBar(settings.speed / (settings.startDistance-settings.minDistance));
		
		public function WikiWordsGame(_w:int,_h:int,lang:String="en") 
		{	
			timer = new Timer(1000 / frameRate);
			
			
			language = lang;
			if (language != "en")
			{
				helpText = helpTextnl;
			}
			w = _w;
			h = _h;
			var gamehelp:String = "WikiWords\n\n";
			gamehelp += "Object of the game is to click away the bubbles not related to the center.\n";
			gamehelp += "Related means they are links on the Wikipedia-page of the center.\n\n";
			gamehelp += "click related: -2\n";
			gamehelp += "click non-related: +1\n\n";
			gamehelp += "--click to continue--";
			help = new HelpView(gamehelp, w, h);
			help.addEventListener("pauseToggle", pauseToggle);
			center = { x:w / 2, y:h / 2 };
			addChild(background);
			addChild(satelliteContainer);
			satelliteContainer.filters = [new GlowFilter(0xffff00,0.4,6,6,6,2)];
			addChild(scoreBox);		
			volumeSwitch.y = h - volumeSwitch.height;
			volumeSwitch.addEventListener(MouseEvent.CLICK, toggleVolume);
			addChild(volumeSwitch);
			wordCollector = new WikiWordsPHP( language, "", 3, 4);
			wordCollector.addEventListener(Event.COMPLETE, wordsLoaded);
			addChild(help);
			timerBar.y = h - timerBar.height;
			timerBar.x = center.x - timerBar.width / 2;
			addChild(timerBar);
		}
		private function pauseToggle(e:Event):void
		{
			paused = !paused;
		}
		private function wordsLoaded(e:Event):void
		{
			generateSatellites();
			addEventListener(Event.ENTER_FRAME, step);		
			sounds.oneup();
		}
		private function toggleVolume(e:MouseEvent):void
		{
			sounds.toggle();
			volumeSwitch.toggle();
		}		
		private function generateSatellites():void
		{
			currentDistance = settings.startDistance;
			var results:*= wordCollector.getResults();
			seed = new Satellite(results.seed);
			seed.moveTo(center.x, center.y);
			seed.addEventListener(MouseEvent.CLICK, satelliteClicked);
			satelliteContainer.addChild(seed);
			angles = getAngles(results.random.length + results.random.length-1);
			var ang:int = 0;
			randomWordsLeftInRound = results.random.length;
			for (var i:int = 0; i < results.random.length; i++) 
			{
				randomSatellites[i] = new Satellite(results.random[i],"random");
				satelliteContainer.addChild(randomSatellites[i]);
				randomSatellites[i].moveTo(center.x + (angles[ang].x * settings.startDistance), center.y + (angles[ang++].y * settings.startDistance));
				randomSatellites[i].addEventListener(MouseEvent.CLICK, satelliteClicked);
			}
			for (i = 0; i < results.related.length; i++) 
			{
				relatedSatellites[i] = new Satellite(results.related[i],"related");
				satelliteContainer.addChild(relatedSatellites[i]);
				relatedSatellites[i].moveTo(center.x + (angles[ang].x * settings.startDistance), center.y + (angles[ang++].y * settings.startDistance));
				relatedSatellites[i].addEventListener(MouseEvent.CLICK, satelliteClicked);
			}			
		}

		private function moveSatellites():void
		{
			satelliteContainer.graphics.clear();
			satelliteContainer.graphics.lineStyle(1);
			satelliteContainer.graphics.drawCircle(center.x, center.y, settings.minDistance);
			satelliteContainer.graphics.lineStyle(3);
			var ang:int = 0;
			for (var i:int = 0; i < randomSatellites.length; i++) 
			{
				var target:* = { x:center.x + (angles[ang].x * currentDistance), y:center.y + (angles[ang].y * currentDistance) };
				if (!randomSatellites[i].isDead)
				{
					satelliteContainer.graphics.moveTo(center.x, center.y);
					satelliteContainer.graphics.lineTo(target.x, target.y);					
				}
				randomSatellites[i].moveTo(target.x,target.y);
				ang++;
			}
			for (i = 0; i < relatedSatellites.length; i++) 
			{
				var target2:* = { x:center.x + (angles[ang].x * currentDistance), y:center.y + (angles[ang].y * currentDistance) };
				satelliteContainer.graphics.moveTo(center.x, center.y);
				satelliteContainer.graphics.lineTo(target2.x, target2.y);				
				relatedSatellites[i].moveTo(target2.x,target2.y);
				ang++;
			}			
		}

		private function satelliteClicked(e:MouseEvent):void
		{

			if (!roundOver)
			{
				if (!e.target.isDead && e.target.type != "seed")
				{
					if (e.target.type == "random")
					{
						sounds.coin();
						e.target.startDeathAnim();
						randomWordsLeftInRound--;
						roundScore++;
					}
					else
					{
						e.target.startWrongAnim();
						sounds.kick();
						roundScore-=2;
					}
				}
				if(e.target.type != "seed")
					updateScore();				
			}
			else
				wordCollector.openPage(e.target.content);

		}
		private function updateScore():void
		{
			setScore(totalScore + roundScore);
		}
		private function setScore(score:int,txt:String=""):void
		{
			scoreBox.setText("Score: " + String(score)+txt);
		}
		
		public function step(e:Event):void
		{		
			if (!paused)
			{
				if (randomWordsLeftInRound == 0 || currentDistance < settings.minDistance)
				{				
					roundEnd();
				}
				else 
				{
					currentDistance-= settings.speed;
					timerBar.step();
					moveSatellites();						
				}
			}
			
		}
		private function cleanupSattelites():void
		{
			for (var i:int = 0; i < randomSatellites.length; i++) 
			{
				satelliteContainer.removeChild(randomSatellites[i]);
			}
			for (i = 0; i < relatedSatellites.length; i++) 
			{
				satelliteContainer.removeChild(relatedSatellites[i]);
			}		
			satelliteContainer.removeChild(seed);
			satelliteContainer.graphics.clear();
			randomSatellites = new Vector.<Satellite>();
			relatedSatellites = new Vector.<Satellite>();			
		}
		
		private function roundEnd():void
		{
			if (roundScore > 0) sounds.key();
			else sounds.bad();
			background.reverse();
			moveSatellites();
			roundOver = true;
			removeEventListener(Event.ENTER_FRAME, step);
			totalScore += roundScore;
			totalScore-= randomWordsLeftInRound;
			roundScore = 0;
			
			setScore(totalScore, "\nRound: "+String(numRounds)+helpText);
			scoreBox.addEventListener(MouseEvent.CLICK, scoreBoxClicked);
		}
		private function scoreBoxClicked(e:MouseEvent):void
		{
			scoreBox.removeEventListener(MouseEvent.CLICK, scoreBoxClicked);
			newRound();
		}


		private function newRound():void
		{	
			timerBar.reset();
			background.reverse();
			setScore(totalScore);
			cleanupSattelites();			
			wordCollector = new WikiWordsPHP(language);
			wordCollector.addEventListener(Event.COMPLETE, wordsLoaded);	
			roundOver = false;
			numRounds++;
		}
		

		
		private function getAngles(n:int):Vector.<*>
		{
			var d:Number = Math.PI * 2 / n;
			var temp:Vector.<*> = new Vector.<*>();
			var _angles:Vector.<*> = new Vector.<*>();
			var deviation:Number =  Math.random();
			for (var i:Number = 0; i < n; i++) 
			{
				temp[i] = { x:Math.cos( d * (i + deviation) ) , y:Math.sin( d * (i + deviation) ) };
			}
			while (temp.length > 0) 
			{
				_angles.push(temp.splice(Math.round(Math.random() * (temp.length - 1)), 1)[0]);
			}
			return _angles;
		}		

		
	}
	
}