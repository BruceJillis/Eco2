package engine 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Player extends FlxSprite {
		private var state:PlayState;
		public var minimap:MiniMap;
		private var elapsed:Number = 0;
		private var compass:Compass;
		private var food_bar:FlxBar;		
		private var water_bar:FlxBar;
		private var food_text:FlxText;
		private var water_text:FlxText;
		private var v:Number = 0;
		private var pv:Number;
		private var wind:Array;
		private var money_text:FlxText;
		private var money_sprite:FlxSprite;
		private var bg:FlxSprite;
		
		public var trade:FlxButton;		
		public var food:Number = 100;
		public var water:Number = 100;		
		public var money:Number = 500;	
		public var inventory:Array = [];
		public var capacity:Number = 20;			
		[Embed(source = "../assets/basic_boat.png")] static public var ImgBasicBoat:Class;
		[Embed(source = "../assets/coins.png")] static public var ImgCoins:Class;

		
		public function Player(state:PlayState, x:int, y:int) {
			this.state = state;
			super(x * 32, y * 32);			
			if (FlxG.getPlugin(FlxControl) == null) {
				FlxG.addPlugin(new FlxControl);				
			}			
			// ui background
			bg = new FlxSprite(FlxG.width - 125, 0);
			bg.makeGraphic(125, 320, 0xff7C7A6C, true);
			bg.scrollFactor = new FlxPoint;
			bg.alpha = 0.8;
			state.add(bg);			
			// basic setup
			BasicStats();
			BasicBoat();			
			// minimap
			this.minimap = new MiniMap(this.state, FlxG.width - 110, 10, 100, 100);			
			this.minimap.follow(this);		
			// compass
			this.compass = new Compass(this.state, FlxG.width - 93, 160);
			this.state.add(this.compass);
			// trade btn
			trade = new FlxButton(FlxG.width - 95, 290, "[T]RADE", onTradeClick);
			trade.label.color = 0xffff00;
			trade.scrollFactor = new FlxPoint();
			state.add(trade);				
		}		
		
		public function onTradeClick():void {
			if (state.modal)
				return
			state.paused = true;
			state.dialog = new TradeDialog(state, state.city);			
		}		
		
		private function BasicStats():void {
			// food
			food_text = new FlxText(FlxG.width - 110, 109, 50, "food");
			food_text.scrollFactor = new FlxPoint;
			food_text.alignment = "left";
			this.state.add(food_text);
			food = 100;
			food_bar = new FlxBar(FlxG.width - 90, 120, FlxBar.FILL_LEFT_TO_RIGHT, 80, 10, this, "food", 0, 100);
			food_bar.createFilledBar(0xff895106, 0xffEA8A0B, true, 0xff000000);
			food_bar.scrollFactor = new FlxPoint;
			this.state.add(food_bar);
			// water
			water_text = new FlxText(FlxG.width - 110, 129, 50, "water");
			water_text.scrollFactor = new FlxPoint;
			water_text.alignment = "left";
			this.state.add(water_text);			
			water = 100;
			water_bar = new FlxBar(FlxG.width - 90, 140, FlxBar.FILL_LEFT_TO_RIGHT, 80, 10, this, "water", 0, 100);
			water_bar.createFilledBar(0xff004272, 0xff0094FF, true, 0xff000000);
			water_bar.scrollFactor = new FlxPoint;
			this.state.add(water_bar);		
			// money
			money_sprite = new FlxSprite(FlxG.width - 100, 255);
			money_sprite.loadGraphic(ImgCoins);
			money_sprite.scrollFactor = new FlxPoint;
			state.add(money_sprite);
			money_text = new FlxText(FlxG.width - 80, 251, 80, money.toString() + '$');
			money_text.alignment = 'left';
			money_text.color = 0xffffee;
			money_text.size = 16;
			money_text.scrollFactor = new FlxPoint;
			state.add(money_text);
		}
		
		private function BasicBoat():void {
			loadRotatedGraphic(ImgBasicBoat, 180, -1, true, true);
			FlxControl.create(this, FlxControlHandler.MOVEMENT_ACCELERATES, FlxControlHandler.STOPPING_DECELERATES, 1, false, false);
			//	The UP key will thrust the ship at a speed of 100px/sec/2
			FlxControl.player1.setThrust("UP", 50);
			FlxControl.player1.setMaximumSpeed(25, 25, true);
			//	And when it's not thrusting, this is the speed at which the ship decelerates back to a stand-still
			FlxControl.player1.setDeceleration(30, 30);
			//	They can also rotate it - rotation will accelerate and decelerate (giving it a smoothing off effect)
			FlxControl.player1.setRotationType(FlxControlHandler.ROTATION_ACCELERATES, FlxControlHandler.ROTATION_STOPPING_DECELERATES);
			//	The rotation speeds - 400 for CCW and CW rotation, 200 as the max rotation speed and 400 for deceleration
			FlxControl.player1.setRotationSpeed(38.5, 38.5, 30, 30);
			//	Set the rotation keys - the default is to use LEFT/RIGHT arrows, so we don't actually need to pass anything here! but they can be whatever you need
			FlxControl.player1.setRotationKeys();
			// set bounds
			FlxControl.player1.setBounds(0, 0, this.state.world.tilemap.width, this.state.world.tilemap.height);
			// adjust bounding box to fit basic boat profile better`						
			centerOffsets();
		}
		
		override public function update():void {
			elapsed += FlxG.elapsed;
			if (elapsed >= 5) {
				elapsed -= 5;
				// update wind direction
				wind = this.state.world.wind.info(Math.round(x / 32), Math.round(y / 32));
				this.compass.setTo(wind[0], wind[1]);
				// update food and water
				var fr:Number = FlxG.random();
				food -= fr;
				water -= fr + FlxG.random();
			}			
			// death
			if (food <= 0) {
				food = 0;
				FlxG.switchState(new DeathState("food"));
			}
			// death
			if (water <= 0) {
				water = 0;
				FlxG.switchState(new DeathState("thirst"));
			}
			// movement induced hunger
			pv = v;
			v = Math.sqrt(velocity.x * velocity.x + velocity.y * velocity.y);
			if ( (v - pv) > 0 ) {
				var r:Number = (v - pv) / 100;
				food -= r;
				water -= r + r/2;
			}			
			if ((wind != null) && !this.state.paused) {
				// wind induced hunger
				food -= (wind[1] / 400);
				water -= (wind[1] / 400) + (wind[1] / 750);
				// add wind force
				x += (Math.cos(wind[0] * Math.PI / 180) * wind[1]) / 25;
				y += (Math.sin(wind[0] * Math.PI / 180) * wind[1]) / 25;			
			}
			if ((x + width) > state.world.tilemap.width) {
				x = state.world.tilemap.width - width;
			}
			if ((y + height) > state.world.tilemap.height) {
				y = state.world.tilemap.height - height;
			}			
			money_text.text = money.toString();
			trade.visible = (state.city != null) ? true : false;
			super.update();
		}
		
		override public function destroy():void {
			state.remove(trade).destroy();
			state.remove(bg).destroy();
			state.remove(this.minimap).destroy();
			state.remove(this.compass).destroy();
			state.remove(food_bar).destroy();
			this.state.remove(food_text);			
			food_text.destroy();			
			this.state.remove(water_bar);
			this.state.remove(water_text);					
			water_bar.destroy();
			water_text.destroy();
			this.state.remove(money_text);					
			this.state.remove(money_sprite);		
		}
	}

}