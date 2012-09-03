package engine {
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.plugin.photonstorm.FlxBar;
	
	public class Compass extends FlxSprite {
		public var A:Number;
		[Embed(source = "../assets/compass2.png")] private static var ImgCompass:Class;	
		[Embed(source = "../assets/lightning.mp3")] private var SoundLightning:Class;
		[Embed(source = "../assets/rain.mp3")] private var SoundRain:Class;
		[Embed(source = "../assets/ocean.mp3")] private var SoundOcean:Class;

		private var state:PlayState;
		private var toangle:Number = 0;
		private var windspeed:FlxBar;
		private var tospeed:uint = 0;
		private var wind_text:FlxText;
		private var windspeed_text:FlxText;
		private var playing_rain:FlxSound = null;
		private var playing_sea:FlxSound = null;
		private var soundswitched:Boolean = false;
		
		public function Compass(state:PlayState, x:uint, y:uint) {
			this.state = state;			
			super(x, y);
			scrollFactor = new FlxPoint();
			width = 69;
			height = 68;
			loadRotatedGraphic(ImgCompass, 16, -1, false);
			// wind direction text
			wind_text = new FlxText(FlxG.width - 110, y - 10, 75, "wind direction");
			wind_text.scrollFactor = new FlxPoint;
			wind_text.alignment = "left";
			this.state.add(wind_text);
			// wind speed text
			windspeed_text = new FlxText(FlxG.width - 110, y + height - 4, 75, "wind speed");
			windspeed_text.scrollFactor = new FlxPoint;
			windspeed_text.alignment = "left";
			this.state.add(windspeed_text);		
			// wind speed bar
			windspeed = new FlxBar(FlxG.width - 100, y + height + 10, FlxBar.FILL_LEFT_TO_RIGHT, 90, 10, null, "", 0, 10);
			windspeed.createFilledBar(0xff545454, 0xffA0A0A0, true, 0xff000000);
			windspeed.currentValue = 0;
			windspeed.scrollFactor = new FlxPoint;
			this.state.add(windspeed);		
			// sounds
			playing_sea = FlxG.loadSound(SoundOcean, 0.55, true);
			playing_sea.play();
			playing_rain = FlxG.loadSound(SoundRain, 0.95, true);				
			soundswitched = false;				
		}
		
		public function setTo(toangle:Number, tospeed:uint):void {
			this.toangle = toangle;
			this.A = toangle - angle;
			if (this.A > 180)
				this.A -= 360;
			if (this.A < -180)
				this.A += 360;
			this.tospeed = tospeed;			
		}
		
		override public function update():void {
			if (this.A > 0) {
				this.angle += 1;
				this.A -= 1;
			} else if (this.A < 0) {
				this.angle -= 1;
				this.A += 1;				
			}
			if (windspeed.currentValue > tospeed) {
				windspeed.currentValue -= 1;
			} else if (windspeed.currentValue < tospeed) {
				windspeed.currentValue += 1;
			}						
					
			FlxG.camera.color = 0xffffff;
			if (windspeed.currentValue > 4) {			
				if (!soundswitched) {
					soundswitched = true;
					playing_rain.play(true);
				}
				if (!this.state.paused) {
					FlxG.camera.color = 0x111111 * (16 - ((windspeed.currentValue - 4) * 2));
				}
				if (windspeed.currentValue >= 7) {
					if (FlxG.random() <= 0.0015) {
						if (!this.state.paused) {
							FlxG.camera.shake(0.015);
							FlxG.camera.flash();	
							FlxG.play(SoundLightning, 0.85, false);
						}
					}	
				}
			} else {
				if (soundswitched) {
					soundswitched = false;
					playing_rain.pause();
				}
			}
			super.update();
		}
		
		override public function destroy():void {
			this.state.remove(this.windspeed);
			this.windspeed.destroy();
			this.state.remove(this.wind_text);
			this.wind_text.destroy();
			this.state.remove(this.windspeed_text);
			this.windspeed_text.destroy();			
			super.destroy();
		}
		
	}

}