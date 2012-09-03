package {
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class DeathState extends FlxState {
		private var reason:FlxText;
		private var elapsed:Number = 0;
		private var ok:FlxButton;
		
		public function DeathState(reason:String = "ultimate") {
			this.reason = new FlxText(FlxG.width / 2 - 250, FlxG.height / 2 - 15, 500, "You died of " + reason);			
			this.reason.alignment = "center"
			this.reason.size = 30;
			this.add(this.reason);
			ok = new FlxButton(FlxG.width / 2 - 42.5, FlxG.height / 2 + 45, "Restart", onOkClick);
			add(ok);
		}
		
		public function onOkClick():void {
			FlxG.switchState(new PlayState);
		}
		
		override public function update():void {			
			elapsed += FlxG.elapsed;
			if (elapsed >= 0.5) {
				elapsed -= 0.5;
				reason.alpha -= 0.1;				
			}
			if (reason.alpha <= 0) {
				FlxG.switchState(new MenuState);
			}
			super.update();			
		}
		
	}

}