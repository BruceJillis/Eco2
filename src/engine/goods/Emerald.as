package engine.goods {
	import org.flixel.FlxG;

	public class Emerald extends Good {
		[Embed(source = "../../assets/emerald.png")] static public var ImgEmerald:Class;
		
		public function Emerald() {
			name = 'Emerald';
			plural = 'emeralds';
			cost = Math.round(Math.max(100, FlxG.random() * 325));
			amount = Math.round(Math.max(1, FlxG.random() * 20));
			fluctuation = 20;
			unit = 'stone';	
			rarity = 0.15;
		}
		
		override public function getImg():Class {
			return ImgEmerald;
		}
		
	}

}