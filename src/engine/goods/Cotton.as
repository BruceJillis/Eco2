package engine.goods {
	import org.flixel.FlxG;

	public class Cotton extends Good {
		[Embed(source = "../../assets/cotton-boll.png")] static public var ImgCottonSmall:Class;
		
		public function Cotton() {
			name = 'Cotton';
			plural = 'cotton';
			cost = Math.round(Math.max(10, FlxG.random() * 25));
			amount = Math.round(Math.max(10, FlxG.random() * 100));
			fluctuation = 0;
			unit = 'kg';	
			rarity = 1.0;
		}
		
		override public function getImg():Class {
			return ImgCottonSmall;
		}
		
	}

}