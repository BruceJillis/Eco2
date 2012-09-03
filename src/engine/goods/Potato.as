package engine.goods {
	import org.flixel.FlxG;

	public class Potato extends Good {
		[Embed(source = "../../assets/potato.png")] static public var ImgPotatoSmall:Class;
		
		public function Potato() {
			name = 'Potato';
			plural = 'potatoes';
			cost = Math.round(Math.max(10, FlxG.random() * 35));
			amount = Math.round(Math.max(10, FlxG.random() * 75));
			fluctuation = 2.5;
			unit = 'kg';			
			rarity = 0.5;
		}
		
		override public function getImg():Class {
			return ImgPotatoSmall;
		}
		
	}

}