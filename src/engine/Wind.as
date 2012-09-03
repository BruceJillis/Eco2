package engine {
	import flash.display.BitmapData;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	
	public class Wind extends FlxSprite {
		private var state:PlayState;
		private var bmd:BitmapData;
		private var objects:Array = new Array;
		private var offsets:Array = new Array;
		private var speeds:Array = new Array;
		private var numOctaves:uint = 1;
		private var elapsed:Number = 0;
		private var seed:Number;
		private var baseX:int = 50;
		private var baseY:int = 50;
		
		public function Wind(state:PlayState, x:Number, y:Number, w:Number, h:Number) {
			this.state = state;
			super(0, 0);
			visible = false;
			width = 0;
			height = 0;
			scrollFactor = new FlxPoint();						
			this.seed = Math.round(FlxG.random() * 456789);
			// draw unscaled			
			bmd = new BitmapData(this.state.world.tilemap.widthInTiles, this.state.world.tilemap.heightInTiles, true, 0xff000000);	
			bmd.perlinNoise(this.baseX, this.baseY, numOctaves, this.seed, false, false, 7, true, offsets);
			// set pixel data
			// pixels = bmd;
			// add it already
			this.state.add(this);
			// Creating points to hold X and Y position of every octave.
			for(var o:uint = 0; o < numOctaves; o++){
				offsets[o] = new Point(0,0);
			}
			// Setting up the speeds at which the octaves will move, one for each octave.
			speeds[0] = new Point(1.1,-2.6);
			speeds[1] = new Point(-2.5,2.2);
			speeds[2] = new Point(1.7,-3.5);			
		}
		
		override public function update():void {
			elapsed += FlxG.elapsed;
			if (elapsed >= 5) {
				elapsed -= 5;
				// Animating the octaves in time
				for(var o:uint = 0; o < numOctaves; o++){
					offsets[o].x += speeds[o].x;
					offsets[o].y += speeds[o].y;
				}
				bmd.perlinNoise(this.baseX, this.baseY, this.numOctaves, this.seed, false, false, 7, true, offsets);
				// dirty = true;
			}
			super.update();			
		}
		
		public function info(x:uint, y:uint):Array {
			var ds:Array = [];
			ds.push([  0, value(x, y - 1)]);
			ds.push([ 45, value(x + 1, y - 1)]);
			ds.push([ 90, value(x + 1, y)]);
			ds.push([135, value(x + 1, y + 1)]);
			ds.push([180, value(x + 1, y)]);
			ds.push([225, value(x + 1, y - 1)]);
			ds.push([270, value(x - 1, y - 1)]);
			ds.push([315, value(x - 1, y + 1)]);
			var max:Array = [0, -999];
			for each(var item:Array in ds) {
				if (Math.abs(item[1]) > max[1]) {
					max = item;
				}
			}
			return max;
		}
		
		private function value(x:uint, y:uint):int {
			return Math.max(0, Math.min(10, Math.round((bmd.getPixel(x, y) / 0xffffff) * 54.0) - 4));
		}
	}

}