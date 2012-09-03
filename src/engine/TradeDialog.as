package engine 
{
	import engine.goods.Good;
	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author 
	 */
	public class TradeDialog extends FlxSprite {
		private var bg:FlxSprite;
		private var state:PlayState;
		private var close:FlxButton;
		private var name:FlxText;
		private var city:City;
		private var sell:FlxText;
		private var bars:Array = [];
		private var player:Player;		
		private var inventory_text:FlxText;
		private var inventory:Array = [];
		private var food:FlxButton;
		private var food_text:FlxText;
		private var water:FlxButton;
		private var water_text:FlxText;
			
		public function TradeDialog(state:PlayState, city:City, w:uint = 450, h:uint = 320) {
			this.state = state;
			this.player = state.world.player;
			this.city = city;
			super((FlxG.width / 2) - (w / 2), (FlxG.height / 2) - (h / 2));
			width = w;
			height = h;			
			scrollFactor = new FlxPoint();
			makeGraphic(width, height, 0xff7F3300);
			this.state.add(this);			
			// close button
			close = new FlxButton(x + w - 85, y + h - 25, "CLOSE", onCloseClick);
			close.scrollFactor = new FlxPoint();
			close.label.scrollFactor = new FlxPoint();
			this.state.add(close);	
			// food button			
			food = new FlxButton(x + w - 195, y + h - 25, "FOOD", onFoodClick);
			food.scrollFactor = new FlxPoint();
			food.label.scrollFactor = new FlxPoint();			
			food.visible = (player.food < 100);
			this.state.add(food);							
			food_text = new FlxText(x + w - 110, y + h - 22, 35, city.foodprice.toString() + '$');
			food_text.scrollFactor = new FlxPoint();
			food_text.alignment = "left";
			food_text.visible = (player.food < 100);
			this.state.add(food_text);
			// water button			
			water = new FlxButton(x + w - 305, y + h - 25, "WATER", onWaterClick);
			water.scrollFactor = new FlxPoint();
			water.label.scrollFactor = new FlxPoint();			
			water.visible = (player.water < 100);
			this.state.add(water);							
			water_text = new FlxText(x + w - 220, y + h - 22, 35, city.waterprice.toString() + '$');
			water_text.scrollFactor = new FlxPoint();
			water_text.alignment = "left";
			water_text.visible = (player.water < 100);
			this.state.add(water_text);
			// city name
			name = new FlxText(x + 5, y + 5, 200, "City: " + city.name);
			name.scrollFactor = new FlxPoint();
			name.alignment = "left";
			this.state.add(name);
			// show goods
			sell = new FlxText(x + 25, y + 25, 200, "Selling");
			sell.scrollFactor = new FlxPoint();
			sell.alignment = "left";
			this.state.add(sell);
			var i:int = 0;
			bars.length = 0;
			for each(var g:Good in city.goods) {
				var r:FlxSprite = new FlxSprite(x + 25, y + 40 + (i * 45));
				r.makeGraphic(200, 40, 0xffD85600);
				r.scrollFactor = new FlxPoint();
				state.add(r);
				var lbl:FlxText = new FlxText(x + 25, y + 40 + (i * 45), 100, g.name);
				lbl.scrollFactor = new FlxPoint();
				state.add(lbl);
				var ico:FlxSprite = new FlxSprite(x + 30, y + 50 + (i * 45));
				ico.loadGraphic(g.getImg());
				ico.scrollFactor = new FlxPoint();
				state.add(ico);		
				var cost:FlxText = new FlxText(x + 60, y + 48 + (i * 45), 25, g.cost.toString());
				cost.color = 0x555555;
				cost.alignment = 'right';
				cost.scrollFactor = new FlxPoint();
				state.add(cost);
				var sep:FlxText = new FlxText(x + 85, y + 48 + (i * 45), 100, '$ / ' + g.unit.toString());				
				sep.alignment = 'left';
				sep.scrollFactor = new FlxPoint();
				state.add(sep);				
				var amount:FlxText = new FlxText(x + 60, y + 64 + (i * 45), 25, g.amount.toString());
				amount.color = 0x555555;
				amount.alignment = 'right';
				amount.scrollFactor = new FlxPoint();
				state.add(amount);	
				var avail:FlxText = new FlxText(x + 85, y + 64 + (i * 45), 150, g.unit.toString() + ' available');				
				avail.alignment = 'left';
				avail.scrollFactor = new FlxPoint();
				state.add(avail);						
				var plus:FlxButton = new FlxButton(x + 144, y + 41 + (i * 45), "buy", buyHandler(g))
				plus.scrollFactor = new FlxPoint();
				state.add(plus);					
				bars.push([r, ico, amount, plus, sep, cost, avail, lbl]);
				i++;
			}
			make_inventory();
		}
		
		public function onFoodClick():void {
			if (state.modal)
				return
			if (city.foodprice > player.money) {
				new Dialog(state, "Error", "You don't have enough money to buy food.");
				return;
			}
			if (player.money < 0) {
				new Dialog(state, "Error", "You don't have enough money to buy food.");
				return;
			}			
			player.money -= city.foodprice;
			city.foodprice += city.foodpricedelta;
			city.foodprice = Math.round(city.foodprice);
			player.food += 1;
			food.visible = (player.food < 100);
			food_text.visible = (player.food < 100);
		}
		
		public function onWaterClick():void {
			if (state.modal)
				return
			if (city.waterprice > player.money) {
				new Dialog(state, "Error", "You don't have enough money to buy water.");
				return;
			}
			if (player.money < 0) {
				new Dialog(state, "Error", "You don't have enough money to buy water.");
				return;
			}			
			player.money -= city.waterprice;
			city.waterprice += city.waterpricedelta;
			city.waterprice = Math.min(20, Math.max(0, Math.round(city.waterprice)));
			player.water += 1;
			water.visible = (player.water < 100);
			water_text.visible = (player.water < 100);
		}
		
		private function make_inventory():void {
			inventory_text = new FlxText(x + 235, y + 25, 200, "Inventory");
			inventory_text.scrollFactor = new FlxPoint();
			inventory_text.alignment = "left";
			state.add(inventory_text);
			var i:int = 0;
			for each(var g:Good in player.inventory) {
				var r:FlxSprite = new FlxSprite(x + 235, y + 40 + (i * 45));
				r.makeGraphic(200, 40, 0xffD85600);
				r.scrollFactor = new FlxPoint();
				state.add(r);
				var lbl:FlxText = new FlxText(x + 235, y + 40 + (i * 45), 100, g.name);
				lbl.scrollFactor = new FlxPoint();
				state.add(lbl);				
				var ico:FlxSprite = new FlxSprite(x + 240, y + 50 + (i * 45));
				ico.loadGraphic(g.getImg());
				ico.scrollFactor = new FlxPoint();
				state.add(ico);						
				g.sell = 0;
				if (city.hasGood(g)) {
					g.sell = Math.round(g.cost / 2);
				} else {
					g.sell = Math.round(g.cost + (FlxG.random() * g.fluctuation));
				}
				var cost:FlxText = new FlxText(x + 265, y + 48 + (i * 45), 25, g.sell.toString());
				cost.color = 0x555555;
				cost.alignment = 'right';
				cost.scrollFactor = new FlxPoint();
				state.add(cost);
				var sep:FlxText = new FlxText(x + 295, y + 48 + (i * 45), 50, '$ / ' + g.unit.toString());				
				sep.alignment = 'left';
				sep.scrollFactor = new FlxPoint();
				state.add(sep);	
				
				var amount:FlxText = new FlxText(x + 265, y + 64 + (i * 45), 25, g.has.toString());
				amount.color = 0x555555;
				amount.alignment = 'right';
				amount.scrollFactor = new FlxPoint();
				state.add(amount);		
				var avail:FlxText = new FlxText(x + 295, y + 64 + (i * 45), 150, g.unit.toString() + ' available');				
				avail.alignment = 'left';
				avail.scrollFactor = new FlxPoint();
				state.add(avail);		
				
				var min:FlxButton = new FlxButton(x + 350, y + 45 + (i * 45), "sell", sellHandler(g))
				min.scrollFactor = new FlxPoint();
				state.add(min);				
				inventory.push([r, ico, lbl, amount, min, sep, cost, avail])
				i += 1;
			}
		}		
		
		private function destroy_inventory():void {
			state.remove(inventory_text);
			for each(var b:Array in inventory) {
				for each(var c:FlxSprite in b) {
					state.remove(c);
					c.destroy();
				}
			}
			inventory = [];
		}
		
		private function buyHandler(g:Good):Function {
			return function():void {
				onBuyClick(g);
			}
		}
		
		override public function update():void {
			food.visible = (player.food < 100);
			food_text.visible = (player.food < 100);
			water.visible = (player.water < 100);
			water_text.visible = (player.water < 100);
			super.update();
		}
		
		
		private function sellHandler(g:Good):Function {
			return function():void {
				onSellClick(g);
			}
		}		
		
		private function onSellClick(g:Good):void {
			if (state.modal)
				return
			if (g.has <= 0) {
				return;
			}
			g.has -= 1;
			player.money += g.sell;
			if (g.has == 0) {
				var i:Array = [];
				for each(var x:Good in player.inventory) {
					if (x.has > 0) {
						i.push(x);
					}
				}
				player.inventory = i;
			}
			redraw();
		}
		
		public function onBuyClick(g:Good):void { 
			if (state.modal)
				return
			if (g.amount <= 0) {
				new Dialog(state, "Error", "It seems there is more "+g.plural+" left to purchase.");
				return;
			}
			if (g.cost > player.money) {
				new Dialog(state, "Error", "You do not have enough money to purchase "+g.plural+".");
				return;
			} 
			if (player.inventory.length >= 4) {
				new Dialog(state, "Error", "You do not have enough space to purchase "+g.plural+".");
				return;				
			}
			var a:int = 0;
			var already:Object = null;
			for each(var pg:Good in player.inventory) {
				a += pg.has;
				if (pg.name == g.name) {
					already = pg;					
				}
			}
			if (a >= player.capacity) {
				new Dialog(state, "Error", "You do not have enough space to purchase that.");
				return;								
			}			
			if (already != null) {
				already.has += 1;
			} else {
				g.has = 1;
				player.inventory.push(g);
			}	
			g.amount -= 1;
			player.money -= g.cost;
			redraw();
		}
		
		private function redraw():void {
			var i:int = 0;			
			for each(var b:Array in bars) {
				b[2].text = city.goods[i].amount.toString();
				i += 1;
			}
			destroy_inventory();
			make_inventory();			
		}		
			
		public function onCloseClick():void {
			if (state.modal)
				return
			state.remove(this);
			state.remove(close);
			close.destroy();
			state.remove(food);
			food.destroy();
			state.remove(food_text);
			food_text.destroy();
			state.remove(water);
			water.destroy();
			state.remove(water_text);
			water_text.destroy();			
			state.remove(name);			
			name.destroy();
			state.remove(sell);			
			sell.destroy();
			for each(var b:Array in bars) {
				for each(var c:FlxSprite in b) {
					state.remove(c);
					c.destroy();
				}
			}
			destroy_inventory();
			state.paused = false;
		}
		
	}

}