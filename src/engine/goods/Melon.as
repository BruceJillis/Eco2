package engine.goods {
	import org.flixel.FlxG;

	public class Melon extends Good {
		[Embed(source = "../../assets/melons.png")] static public var ImgMelon:Class;
		
		public function Melon() {
			name = 'Melon';
			plural = 'melons';
			cost = Math.round(Math.max(10, FlxG.random() * 25));
			amount = Math.round(Math.max(10, FlxG.random() * 100));
			fluctuation = 0;
			unit = 'melon';	
			rarity = 0.75;
		}
		
		override public function getImg():Class {
			return ImgMelon;
		}
		
	}

}