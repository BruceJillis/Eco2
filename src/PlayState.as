package {
	import engine.*;
	import mx.core.FlexSprite;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	public class PlayState extends FlxState {
		public var paused:Boolean = false;
		public var dialog:TradeDialog = null;
		public var city:City;
		public var world:World;
		public var modal:Boolean = false;
		
		override public function create():void {						
			// create a world
			world = new World(this, Math.max(100, FlxG.random() * 256), Math.max(100, FlxG.random() * 256));
			//world = new World(this, 15, 15);
			world.generate();		

		}
		
		override public function update():void {
			/*
			if (FlxG.keys.justPressed("BACKSPACE")) {
				if (dialog != null) {
					dialog.destroy();
				}
				world.destroy();
				world = new World(this, Math.max(100, FlxG.random() * 256), Math.max(100, FlxG.random() * 256));
				//world = new World(this, 15, 15);
				world.generate();
			}
			*/
			if (!paused) {
				world.update();
				FlxG.collide(world.player, world.tilemap);			
				city = null;
				FlxG.overlap(world.player, world.cities, onPlayerCollideCity);				
			}
			if (dialog != null) {
				dialog.update();
			}
			super.update();
			if (FlxG.keys.justPressed("T")) {
				if (city != null) {
					world.player.onTradeClick();
				}
			}
			/*
			if (FlxG.keys.justPressed("SPACE")) {
				paused = true;
				dialog = new TradeDialog(this, world.cities.members[0]);	
			}
			*/
		}
		
		public function onPlayerCollideCity(player:FlxBasic, o:FlxBasic):void {			
			city = o as City;			
		}
		
		override public function destroy():void {						
			world.destroy();
			if (dialog != null) {
				dialog.destroy();
			}			
			super.destroy();
		}
	}
}