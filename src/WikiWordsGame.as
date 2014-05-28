package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;

	public class WikiWordsGame extends Sprite
	{
		//game-settings
		private var secondsPerRound:Number = 20;
		private var frameRate:int = 25;
		private var startDist:Number = 220;
		private var endDist:Number = 90;	
		private var amFrames:int = int(frameRate * secondsPerRound);
		private var stepDist:Number = (startDist - endDist) / (frameRate * secondsPerRound);
		private var maxBonus:int = 50;
		private var bonusStep:Number = maxBonus / amFrames;
		private var penalty:int = 25;
		private var prize:int = 5;
		private var amRel:int = 3;
		private var amRan:int = 4;
		private var levelChange:int = 200;
		//screen-elements
		private var background:AnimatedBackground = new AnimatedBackground();
		private var satelliteContainer:Sprite = new Sprite();
		private var scoreBox:InfoPanel;	
		private var volumeSwitch:VolumeSwitch;	
		private var timerBar:FillBar;
		private var seed:Satellite;
		private var randomSatellites:Vector.<Satellite> = new Vector.<Satellite>();
		private var relatedSatellites:Vector.<Satellite> = new Vector.<Satellite>();
		private var help:HelpView;	
		private var levelPopup:LevelPopup;
		//game-elements
		private var angles:Vector.<*>;
		private var center:*;
		private var helpText:String = "\nClick here for next round\nClick word for related Wikipedia-page";
		private var helpTextnl:String = "\nKlik hier voor de volgende ronde\nKlik woord voor Wikipedia-pagina";		
		private var wordCollector:WikiWordsPHP;
		private var sounds:SoundManager = new SoundManager();		
		//variables
		private var bonus:Number = maxBonus;
		private var currentDistance:Number;
		private var roundOver:Boolean = false;
		private var w:int;
		private var h:int;
		private var randomWordsLeftInRound:int;
		private var totalScore:int = 0;
		private var roundScore:int = 0;
		private var language:String;
		private var paused:Boolean = false;
		private var numRounds:int = 1;
		private var currentLevel:int = 0;
		private var xmlGenerator:String;
		
		public function WikiWordsGame(_w:int,_h:int,url:String,lang:String="en") 
		{	
			language = lang;
			xmlGenerator = url;
			helpText = (language != "en")?helpTextnl:helpText;

			w = _w;
			h = _h;
			center = { x:w / 2, y:h / 2 };
			
			addChild(background);
			addChild(satelliteContainer);
			satelliteContainer.filters = [new GlowFilter(0xffff00, 0.4, 6, 6, 6, 2)];
			
			scoreBox = new InfoPanel();
			addChild(scoreBox);	
			
			setupVolumeSwitch();
			setupTimerBar();
			setupHelp();
			levelPopup = new LevelPopup(w, h);
			addChild(levelPopup);
			wordCollector = new WikiWordsPHP(xmlGenerator,language,"",amRel,amRan);
			wordCollector.addEventListener(Event.COMPLETE, wordsLoaded);
		}
		
		private function setSecondsPerRound(spr:int):void
		{
			secondsPerRound = spr;
			amFrames = int(frameRate * secondsPerRound);
			stepDist = (startDist - endDist) / (frameRate * secondsPerRound);
			bonusStep = maxBonus / amFrames;
			timerBar.setTotalFrames(frameRate * secondsPerRound);
		}
		
		private function setupVolumeSwitch():void
		{
			volumeSwitch = new VolumeSwitch();
			volumeSwitch.y = h - volumeSwitch.height;
			volumeSwitch.addEventListener(MouseEvent.CLICK, toggleVolume);
			addChild(volumeSwitch);			
		}
		
		private function setupTimerBar():void
		{
			timerBar = new FillBar((secondsPerRound * frameRate),maxBonus);
			timerBar.y = h - timerBar.height;
			timerBar.x = center.x - timerBar.width / 2;
			addChild(timerBar);			
		}
		
		private function setupHelp():void
		{
			var gamehelp:String = "WikiWords\n\n";
			gamehelp += "Object of the game is to click away the bubbles not related to the center.\n";
			gamehelp += "Related means they are links on the Wikipedia-page of the center.\n\n";
			gamehelp += "click related: -"+String(penalty)+"\n";
			gamehelp += "click non-related: +" + String(prize) + "\n\n";
			gamehelp += "For every "+String(levelChange)+" points, an extra related bubble appears.\n\n";
			gamehelp += "--click to continue--";
			help = new HelpView(gamehelp, w, h);
			help.addEventListener("pauseToggle", pauseToggle);
			addChild(help);			
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
			currentDistance = startDist;
			var results:*= wordCollector.getResults();
			seed = new Satellite(results.seed);
			seed.moveTo(center.x, center.y);
			seed.addEventListener(MouseEvent.CLICK, satelliteClicked);
			satelliteContainer.addChild(seed);
			angles = getAngles(results.random.length + results.related.length);
			var ang:int = 0;
			randomWordsLeftInRound = results.random.length;
			for (var i:int = 0; i < results.random.length; i++) 
			{
				randomSatellites[i] = new Satellite(results.random[i],"random");
				satelliteContainer.addChild(randomSatellites[i]);
				randomSatellites[i].moveTo(center.x + (angles[ang].x * startDist), center.y + (angles[ang++].y * startDist));
				randomSatellites[i].addEventListener(MouseEvent.CLICK, satelliteClicked);
			}
			for (i = 0; i < results.related.length; i++) 
			{
				relatedSatellites[i] = new Satellite(results.related[i],"related");
				satelliteContainer.addChild(relatedSatellites[i]);
				relatedSatellites[i].moveTo(center.x + (angles[ang].x * startDist), center.y + (angles[ang++].y * startDist));
				relatedSatellites[i].addEventListener(MouseEvent.CLICK, satelliteClicked);
			}			
		}
		
		private function moveSatellites():void
		{
			satelliteContainer.graphics.clear();
			satelliteContainer.graphics.lineStyle(1);
			satelliteContainer.graphics.drawCircle(center.x, center.y, endDist);
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
						e.target.startDeathAnim(prize);
						randomWordsLeftInRound--;
						roundScore += prize;
					}
					else
					{
						e.target.startWrongAnim(penalty);
						sounds.kick();
						roundScore-=penalty;
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
			scoreBox.updateScore(score);
		}
		
		public function step(e:Event):void
		{		
			if (!paused)
			{
				if (randomWordsLeftInRound == 0 || currentDistance < endDist)
				{				
					roundEnd();
				}
				else 
				{
					bonus -= bonusStep;
					currentDistance-= stepDist;
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
			background.reverse();
			moveSatellites();			
			roundOver = true;
			removeEventListener(Event.ENTER_FRAME, step);	
			var roundupText:String = "Round: " + String(numRounds) + "\nScore this round: " + String(roundScore) + "\nBonus: " + String(int(bonus)) +"\n" + helpText;			
			roundScore += int(bonus);
			totalScore += int(roundScore);	
			scoreBox.showData(totalScore,roundupText);		
			if (roundScore > 0) sounds.key();
			else sounds.bad();
			bonus = maxBonus;
			roundScore = 0;
			scoreBox.addEventListener(MouseEvent.CLICK, scoreBoxClicked);
			
		}
		
		private function scoreBoxClicked(e:MouseEvent):void
		{
			scoreBox.removeEventListener(MouseEvent.CLICK, scoreBoxClicked);
			newRound();
		}

		private function newRound():void
		{			
			if (int(totalScore / levelChange) != currentLevel)
			{
				currentLevel = int(totalScore / levelChange);			
				levelPopup.showPopup("You reached level "+String(currentLevel+1));				
			}
			timerBar.reset();			
			background.reverse();
			setScore(totalScore);
			cleanupSattelites();	
			wordCollector = new WikiWordsPHP(xmlGenerator,language,"",amRel+currentLevel,amRan);
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