package engine.goods {
	import org.flixel.FlxG;

	public class Grape extends Good {
		[Embed(source = "../../assets/cotton-boll.png")] static public var ImgCottonSmall:Class;
		
		public function Grape() {
			name = 'Grape';
			plural = 'grape';
			cost = Math.round(Math.max(10, FlxG.random() * 25));
			amount = Math.round(Math.max(10, FlxG.random() * 100));
			fluctuation = 0;
			unit = 'bunch';	
			rarity = 0.55;
		}
		
		override public function getImg():Class {
			return ImgCottonSmall;
		}
		
	}

}