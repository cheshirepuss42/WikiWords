package  
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;

	
	/**
	 * ...
	 * @author 
	 */
	public class SoundManager 
	{
		[Embed(source = 'assets/smw_1-up.mp3')]private const sound1:Class;
		[Embed(source = 'assets/smw_stomp.mp3')]private const sound2:Class;
		[Embed(source = 'assets/smw_key.mp3')]private const sound3:Class;
		[Embed(source = 'assets/smw_coin.mp3')]private const sound4:Class;
		[Embed(source = 'assets/bad.mp3')]private const sound5:Class;
		[Embed(source = 'assets/alarm.mp3')]private const sound6:Class;
		private var sounds:Vector.<Sound>;
		private var channel:SoundChannel;
		private var soundOn:Boolean = true;
		private var transform:SoundTransform= new SoundTransform();
		
		public function SoundManager() 
		{
			channel = new SoundChannel();
			sounds = new Vector.<Sound>();
			channel.soundTransform = transform;
			sounds.push(new sound1());
			sounds.push(new sound2());
			sounds.push(new sound3());
			sounds.push(new sound4());	
			sounds.push(new sound5());	
			sounds.push(new sound6());
			setVolume(0.6);
		}
		public function alarm():void
		{			
			channel = sounds[5].play();
		}
		public function oneup():void
		{
			channel = sounds[0].play();
		}
		public function key():void
		{
			channel = sounds[2].play();
		}		
		public function coin():void
		{
			channel = sounds[3].play();
		}	
		public function kick():void
		{
			channel = sounds[1].play();
		}	
		public function bad():void
		{
			channel = sounds[4].play();			
		}		
		public function allStop():void
		{
			channel.stop();
		}
		public function setVolume(v:Number=1):void
		{
			var s:SoundTransform = new SoundTransform();
			s.volume = v;
			SoundMixer.soundTransform = s;	
		}
		public function toggle():void
		{
			var s:SoundTransform = new SoundTransform();
			if(soundOn)
			{
				s.volume=0;
				soundOn = false;
			}
			else // sound is off
			{
				s.volume=1;
				soundOn = true;
			}
			SoundMixer.soundTransform = s;					
		}
	}
	
}