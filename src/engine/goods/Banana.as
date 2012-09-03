package engine.goods {
	import org.flixel.FlxG;

	public class Banana extends Good {
		[Embed(source = "../../assets/banana.png")] static public var ImgBanana:Class;
		
		public function Banana() {
			name = 'Banana';
			plural = 'bananas';
			cost = Math.round(Math.max(10, FlxG.random() * 25));
			amount = Math.round(Math.max(10, FlxG.random() * 100));
			fluctuation = 0;
			unit = 'bunch ';	
			rarity = 0.75;
		}
		
		override public function getImg():Class {
			return ImgBanana;
		}
		
	}

}