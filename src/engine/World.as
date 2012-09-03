package engine {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GraphicsPathWinding;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxControl;

	public class World {
		private var state:PlayState;		
		public var w:int;
		public var h:int;		
		
		// array containing all water tile's
		private var water:Array = new Array;
		
		[Embed(source = "../assets/tilemap2.png")] static public var TileSet:Class;
		
		public var data:Array;
		private var auto:Array;
		private var grass:Array = new Array;
		public var cities:FlxGroup = new FlxGroup;
		
		public var wind:Wind;
		public var tilemap:FlxTilemap;
		public var player:Player;
		
		public function World(state:PlayState, w:int, h:int) {
			this.state = state;			
			this.w = w;
			this.h = h;
			FlxG.worldBounds.make(0, 0, w * 32, h * 32);	
			// create flxtilemap and render the map data to it
			tilemap = new FlxTilemap();			
			this.state.add(tilemap);
		}	

		public function generate():void {		
			noise();
			autotile();
			// place cities
			for (var i:int = 0; i < Math.max(w, h); i++) {
				found = false;
				var count:int = 0;
				while (!found && (count <= 100)) {
					count++;
					var pos:* = FlxU.getRandom(grass);
					// check if there is water 2 blocks away
					if (tile(data, pos[0], pos[1]+2) == 0) {
						found = true;
					} else if (tile(data, pos[0]+2, pos[1]) == 0) {
						found = true;
					} else if (tile(data, pos[0]-2, pos[1]) == 0) {
						found = true;
					} else if (tile(data, pos[0], pos[1]-2) == 0) {
						found = true;	
					} else if (tile(data, pos[0]+1, pos[1]) == 0) {
						found = true;
					} else if (tile(data, pos[0]-1, pos[1]) == 0) {
						found = true;
					} else if (tile(data, pos[0], pos[1]-1) == 0) {
						found = true;							
					} else if (tile(data, pos[0], pos[1]+1) == 0) {
						found = true;							
					}
					if (found) {
						var p:FlxPoint = new FlxPoint(pos[1] * 32, pos[0] * 32);
						for each(var c:City in cities.members) {
							var d:int = FlxU.getDistance(c.getMidpoint(), p) / 32;
							if (d < 10) {
								found = false;
								continue;
							}
						}
					}
				}
				if (found) {
					cities.add(new City(this.state, pos[1] * 32, pos[0] * 32))
				}
			}			
			// load final data into the tilemap
			tilemap.loadMap(this.toString(), TileSet, 32, 32, FlxTilemap.OFF);
			tilemap.setTileProperties(16, FlxObject.NONE);
			tilemap.setTileProperties(13, FlxObject.ANY);
			tilemap.setTileProperties(19, FlxObject.ANY);
			tilemap.follow();				
			// spawn the player
			var found:Boolean = false;
			while (!found) {
				pos = FlxU.getRandom(water);
				if (tile(data, pos[0], pos[1]+1) == 0) {
					found = true;
				}
			}
			// create wind
			this.wind = new Wind(this.state, 10, 10, w, h);			
			// create and position
			player = new Player(this.state, pos[1], pos[0]);
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);	
			FlxG.camera.deadzone.width -= 110;
			FlxG.camera.setBounds(0, 0, w * 32, h * 32);			
			this.state.add(player);
			FlxG.worldBounds.make(0, 0, w * 32, h * 32);			
		}
		
		private function autotile():void {
			auto = new Array();
			for (var y:uint = 0; y < h; y++) {
				auto[y] = new Array();
				for (var x:uint = 0; x < w; x++) {	
					auto[y][x] = 16;
					if (data[y][x] == 1) {
						// beach
						auto[y][x] = 13;
					} else if (data[y][x] == 2) {
						// grass
						auto[y][x] = 19;
						grass.push([y, x]);
					}				
				}
			}				
		}
		
		public function destroy():void {
			this.state.remove(tilemap);
			tilemap.destroy();
			this.state.remove(player);
			player.destroy();
			this.state.remove(wind);
			wind.destroy();
			for each(var c:City in cities) {
				this.state.remove(c);
				c.destroy();
			}
			cities.length = 0;
		}
		
		public function update():void {
			for each(var c:City in cities.members) {
				if (c.onScreen(FlxG.camera) && !c.followed) {
					this.player.minimap.follow(c, 0xffFBFF1E);
					c.followed = true;
				}
			}
		}
		
		private function noise():void {
			data = new Array();
			// truncate previous water tiles array to clear it
			water.length = 0;
			// calc new seed
			var seed:int = Math.round(FlxG.random() * 1234567);
			// generate some perlin data
			var perlin:BitmapData = new BitmapData(w, h, false, 0);
			perlin.perlinNoise(8.7, 7.9, 2, seed, false, false, 1, true);	
			// read perlin data into tilemap
			for (var y:uint = 0; y < h; y++) {
				data[y] = new Array();
				for (var x:uint = 0; x < w; x++) {					
					data[y][x] = Math.round((perlin.getPixel(x, y) / 0xffffff) * 16) - 4;
					data[y][x] = Math.min(Math.max(data[y][x], 0), 2);
				}				
			}
			// do smoothing a nr of times
			for (var c:uint = 0; c <= 3; c++ ) {
				// guarantee see borders beach and beach borders grass
				for (y = 0; y < h; y++) {
					for (x = 0; x < w; x++) {
						// for grass
						if (data[y][x] == 2) {							
							// check if any border is sea and change to beach if so
							if (tile(data, y + 1, x) == 0)
								data[y][x] = 1;
							if (tile(data, y, x + 1) == 0)
								data[y][x] = 1;							
							if (tile(data, y - 1, x) == 0)
								data[y][x] = 1;
							if (tile(data, y, x - 1) == 0)
								data[y][x] = 1;	

						}
					}				
				}
				// periodic cleanup
				for (y = 0; y < h; y++) {
					for (x = 0; x < w; x++) {
						// if a tile is beach, count nr of sea tiles
						if (data[y][x] == 1) {				
							if (count(y, x, 0) >= 3) {
								// remove freestanding beach tiles
								data[y][x] = 0;
							}
						}
					}				
				}
			}
			// cleanup that runs only a single time
			for (y = 0; y < h; y++) {
				for (x = 0; x < w; x++) {
					// if a tile is grass, count nr of sea tiles on diagonals
					if (data[y][x] == 2) {				
						if (diag(y, x, 0) >= 1) {
							// change to beach
							data[y][x] = 1;
						}
					}					
					if (data[y][x] == 0) {
						water.push([y, x]);
					}
				}				
			}			
		}
		
		// simple safe accessor that wraps around the edges
		private function tile(arr:Array, y:uint, x:uint):uint {
			return arr[y % h][x % w];	
		}

		
		// render the data array to a string
		private function toString(arr:Array = null):String {
			if (arr == null) {
				arr = auto;
			}
			var result:String = "";
			for (var y:uint = 0; y < arr.length; y++) {
				for (var x:uint = 0; x < arr[y].length; x++) {
					result += arr[y][x].toString() + ",";
				}
				result = result.substring(0, result.length - 1) + '\n';
			}
			return result;
		}			
		
		// count occurences of tile t in top, left, right bottom neighbourhood of x,y
		private function count(y:uint, x:uint, t:uint = 0):uint {
			var count:uint = 0;
			count += (tile(data, y + 1, x) == t) ? 1 : 0;
			count += (tile(data, y, x + 1) == t) ? 1 : 0;
			count += (tile(data, y - 1, x) == t) ? 1 : 0;
			count += (tile(data, y, x - 1) == t) ? 1 : 0;
			return count;
		}

		// count occurences of tile t on the diagonals top-left, bottom-left, bottom-right, top-right
		private function diag(y:uint, x:uint, t:uint = 0):uint {
			var count:uint = 0;
			count += (tile(data, y-1, x-1) == t) ? 1 : 0;
			count += (tile(data, y-1, x+1) == t) ? 1 : 0;
			count += (tile(data, y+1, x-1) == t) ? 1 : 0;
			count += (tile(data, y+1, x+1) == t) ? 1 : 0;
			return count;
		}
		
	}

}