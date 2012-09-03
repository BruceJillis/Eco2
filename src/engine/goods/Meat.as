package engine.goods {
	import org.flixel.FlxG;

	public class Meat extends Good {
		[Embed(source = "../../assets/meat.png")] static public var ImgMeat:Class;
		
		public function Meat() {
			name = 'Meat';
			plural = 'meat';
			cost = Math.round(Math.max(10, FlxG.random() * 25));
			amount = Math.round(Math.max(10, FlxG.random() * 100));
			fluctuation = 0;
			unit = 'piece';	
			rarity = 0.65;
		}
		
		override public function getImg():Class {
			return ImgMeat;
		}
		
	}

}