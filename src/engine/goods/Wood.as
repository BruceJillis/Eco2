package engine.goods {
	import org.flixel.FlxG;

	public class Wood extends Good {
		[Embed(source = "../../assets/wood.png")] static public var ImgWood:Class;
		
		public function Wood() {
			name = 'Wood';
			plural = 'logs';
			cost = Math.round(Math.max(10, FlxG.random() * 25));
			amount = Math.round(Math.max(10, FlxG.random() * 100));
			fluctuation = 5;
			unit = 'log';	
			rarity = 0.75;
		}
		
		override public function getImg():Class {
			return ImgWood;
		}
		
	}

}