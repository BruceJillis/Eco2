package {
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class MenuState extends FlxState {
		private var instructions:FlxButton;
		private var start:FlxButton;

		public function MenuState() {
			start = new FlxButton(FlxG.width / 2 - 40, FlxG.height / 2 - 50, "Start", onStartClick);
			add(start);
			instructions = new FlxButton(FlxG.width / 2 - 40, FlxG.height / 2 , "Instructions", onInstructionsClick);
			add(instructions);			
		}
		
		public function onStartClick():void {
			FlxG.switchState(new PlayState);
			
		}
		
		public function onInstructionsClick():void {
			FlxG.switchState(new InstructionsState);
		}
		
		override public function destroy():void {
			remove(start).destroy();
			remove(instructions).destroy();
			super.destroy();
		}
			
		override public function update():void {		
			super.update();
		}
		
	}

}