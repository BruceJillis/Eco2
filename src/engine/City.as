package engine {
	import engine.goods.*;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	

	public class City extends FlxSprite {		
		private var state:PlayState;
		private var label:FlxText;				
		private var maxgoods:int;
		public var followed:Boolean = false;
		public var name:String;		
		public var goods:Array = [];
		public var bg:FlxSprite;
		
		[Embed(source = "../assets/village.png")] static public var ImgVillage:Class;
		[Embed(source = "../assets/circle.png")] static public var ImgCircle:Class;
		public var foodprice:Number;
		public var foodpricedelta:Number;
		public var waterprice:Number;
		public var waterpricedelta:Number;
		
		
		public function City(state:PlayState, x:int, y:int) {
			this.state = state;			
			width = 192;
			height = 192;
 			super((x + 16) - (width / 2), (y + 16) - (height/2));			
			loadGraphic(ImgCircle);
			this.state.add(this);
			name = NameGenerator.generate();
			// label
			var mp:* = getMidpoint();
			label = new FlxText(mp.x - 37.5, mp.y - 30, 75, name);
			label.alignment = "center";
			label.color = 0x0026FF;
			this.state.add(label);
			// actual village graphic
			mp = getMidpoint();
			bg = new FlxSprite(mp.x - 16, mp.y - 16);
			bg.loadGraphic(ImgVillage, false);
			this.state.add(bg);
			// goods
			maxgoods = Math.round(Math.min(5, Math.max(1, FlxG.random() * 6)));
			var gs:* = [new Cotton(), new Potato(), new Emerald(), new Wood(), new Banana(), new Melon()];
			for each(var g:Good in gs) {
				if (FlxG.random() < g.rarity) {
					goods.push(g);
				}
				// no more then max
				if (goods.length == maxgoods)
					break;
			}	
			// food & water price
			foodprice = Math.round(Math.max(1, FlxG.random() * 10));			
			waterprice = Math.round(Math.max(1, FlxG.random() * 7));			
			foodpricedelta = 0.5 - FlxG.random();
			waterpricedelta = foodpricedelta / 2;
		}
		
		override public function destroy():void {
			state.remove(bg);
			state.remove(label);
			state.remove(this);
			super.destroy();
		}
		
		public function hasGood(g:Good):Boolean {
			for each(var gg:Good in goods) {
				if (gg.name == g.name) {
					return true;
				}
			}
			return false;			
		}
		
	}

}