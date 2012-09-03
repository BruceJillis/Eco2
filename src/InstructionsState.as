package {
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class InstructionsState extends FlxState {
		private var keys:FlxSprite;
		private var keys_text:FlxText;
		private var boat:FlxSprite;
		private var ok:FlxButton;
		private var trade_text:FlxText;
		private var trade_img:FlxSprite;
		private var trade_img2:FlxSprite;
		private var trade_text2:FlxText;
		
		[Embed(source = "assets/arrowkeys.png")] static public var ImgKeys:Class;
		[Embed(source = "assets/basic_boat.png")] static public var ImgBasicBoat:Class;
		[Embed(source = "assets/tradehelp1.png")] static public var ImgTradeHelp1:Class;
		[Embed(source = "assets/tradehelp2.png")] static public var ImgTradeHelp2:Class;

		
		public function InstructionsState() {	
			keys = new FlxSprite(5, 10);
			keys.loadGraphic(ImgKeys);
			add(keys);
			keys_text = new FlxText(115, 5, 500, "Use the arrow keys to control your sailing boat in this epic and unforgiving ecological and economical simulation game.");
			keys_text.size = 11;
			add(keys_text);	
			boat = new FlxSprite(325, 40);
			boat.loadGraphic(ImgBasicBoat);
			add(boat);
			trade_text = new FlxText(15, 95, 260, "Trade goods between villages and turn a profit! Transport wooden logs, blocks of melons or even the elusive emerald. It's all up to you in this one of a lifetime sailing simulator. \n\n Use the [t] key to access the trading menu when you are near a village (trading distance is indicated by the blue square). Don't forget to refresh your water and food supply!");
			trade_text.size = 11;
			add(trade_text);
			trade_img = new FlxSprite(290, 90);
			trade_img.loadGraphic(ImgTradeHelp1);			
			add(trade_img);
			trade_img2 = new FlxSprite(10, 265);
			trade_img2.loadGraphic(ImgTradeHelp2);			
			add(trade_img2);			
			trade_text2 = new FlxText(420, 265, 200, "You will find the different villages very eager to buy anything that's not in stock but can you find them all? \n\n Go forth and explore on the high winds of the islands.");
			trade_text2.size = 11;
			add(trade_text2);			
			ok = new FlxButton(FlxG.width - 100, FlxG.height - 40, "OK", onOkClick);
			add(ok);					
		}
		
		public function onStartClick():void {		
		}
		
		public function onOkClick():void {
			FlxG.switchState(new MenuState);
		}
		
		override public function destroy():void {
			remove(keys).destroy();
			remove(keys_text).destroy();
			remove(boat).destroy();
			remove(trade_text).destroy();
			remove(trade_img).destroy();
			remove(trade_text2).destroy();
			remove(trade_img2).destroy();
			super.destroy();
		}
			
		override public function update():void {		
			super.update();
		}
		
	}

}