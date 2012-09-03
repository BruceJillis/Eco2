package engine {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import mx.core.FlexSprite;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	

	public class MiniMap extends FlxSprite {
		[Embed(source = "../assets/minimap.png")] private static var ImgMinimap:Class;				
		private var state:PlayState;
		private var bmd:BitmapData;
		private var objects:Array = new Array;
		private var sx:Number;
		private var sy:Number;		
		private var background:FlxSprite;				
		private var followed:* = {};
		
		public function MiniMap(state:PlayState, x:uint, y:uint, w:uint, h:uint) {
			this.state = state;
			super(x, y);
			width = w;
			height = h;
			scrollFactor = new FlxPoint();						
			read();
			scaleTo(w, h);			
			// set pixel data
			pixels = bmd;		
			// add it before the background
			this.state.add(this);
			// minimap background
			background = new FlxSprite();
			background.loadGraphic(ImgMinimap);
			background.x = FlxG.width - 110;
			background.y = 10;
			background.scrollFactor = new FlxPoint;
			this.state.add(background);			
		}
		
		private function scaleTo(w:uint, h:uint):void {
			var tm:FlxTilemap = this.state.world.tilemap;
			// scale			
			var s:Number = w / tm.widthInTiles;
			if (tm.heightInTiles > tm.widthInTiles) {
				s = h / tm.heightInTiles;
			}
			var matrix:Matrix = new Matrix();
			matrix.scale(s, s);
			var scaled:BitmapData = new BitmapData(bmd.width * s, bmd.height * s, true, 0xff000000);
			scaled.draw(bmd, matrix, null, null, null, true);
			bmd = scaled;
			// scale factor pre compute
			sx = tm.width / bmd.width;
			sy = tm.height / bmd.height;
			// offset
			offset.x = -((w / 2) - (bmd.width / 2));
			offset.y = -((h / 2) - (bmd.height / 2));
		}
		
		private function read():void {
			// draw unscaled
			bmd = new BitmapData(this.state.world.tilemap.widthInTiles, this.state.world.tilemap.heightInTiles, true, 0xff000000);			
			for (var y:int = 0; y < bmd.height; y++) {
				for (var x:int = 0; x < bmd.width; x++) {				
					switch(this.state.world.data[y][x]) {
						case 0:
							bmd.setPixel(x, y, 0x0000ff);
							break;
						case 1:
							bmd.setPixel(x, y, 0xffff00);
							break;
						case 2:
							bmd.setPixel(x, y, 0x00ff00);
							break;							
					}
				}
			}
			bmd = blur(bmd, 255);
		}
		
		private function blur(bitmapdata:BitmapData, blurvalue:Number = 4):BitmapData {
			var result:BitmapData = bitmapdata.clone();
			var blur:BlurFilter = new BlurFilter();
			blur.blurX = blurvalue; 
			blur.blurY = blurvalue; 
			blur.quality = BitmapFilterQuality.LOW;
			bitmapdata.applyFilter(result, new Rectangle(0, 0, bitmapdata.width, bitmapdata.height), new Point(0,0), blur);
			return result;			
		}
		
		public function follow(obj:FlxSprite, color:uint = 0xFFFF0000):void	{
			var dot:FlxSprite = new FlxSprite();
			dot.makeGraphic(3, 3, color);
			dot.scrollFactor = new FlxPoint();
			this.state.add(dot);			
			objects.push([obj, dot]);
		}
		
		override public function destroy():void {
			this.state.remove(this.background);
			this.background.destroy();			
			for (var i:uint = 0; i < objects.length; i++) {
				this.state.remove(objects[i][1]);
				objects[i][1].destroy();
			}			
		}
		
		override public function update():void {
			for (var i:uint = 0; i < objects.length; i++) {
				objects[i][1].x = x + int(objects[i][0].x / sx) - offset.x;
				objects[i][1].y = y + int(objects[i][0].y / sy) - offset.y;
			}
			super.update();
		}
		
	}

}