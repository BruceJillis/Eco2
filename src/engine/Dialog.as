package engine 
{
	import mx.core.FlexSprite;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author 
	 */
	public class Dialog extends FlxSprite {
		private var title:FlxText;
		private var message:FlxText;
		private var state:PlayState;
		private var close:FlxButton;
		private var bg:FlxSprite;
		
		public function Dialog(state:PlayState, caption:String, msg:String, w:uint = 200, h:uint = 150) {
			this.state = state;
			state.modal = true;
			super((FlxG.width / 2) - (w / 2), (FlxG.height / 2) - (h / 2));
			width = w;
			height = h;
			scrollFactor = new FlxPoint();
			makeGraphic(width, height, 0xff303030);
			// modal backdrop
			bg = new FlxSprite(0, 0);			
			bg.makeGraphic(FlxG.width, FlxG.height, 0x99eeeeee);
			bg.scrollFactor = new FlxPoint;
			bg.alpha = 0.3;
			state.add(bg);
			state.add(this);
			// title
			title = new FlxText(x + 5, y + 5, w, caption);
			title.size = 15;
			title.scrollFactor = new FlxPoint;
			state.add(title);
			// message
			message = new FlxText(x + 5, y + 25, w, msg);
			message.size = 12;
			message.scrollFactor = new FlxPoint;
			state.add(message);						
			// close button
			close = new FlxButton(x + w - 85, y + h - 25, "OK", onCloseClick);
			close.scrollFactor = new FlxPoint();
			close.label.scrollFactor = new FlxPoint();
			this.state.add(close);				
		}
		
		public function onCloseClick():void {
			this.destroy();
		}
		
		override public function destroy():void {
			state.modal = false;
			state.remove(this);
			state.remove(title);			
			state.remove(message);
			state.remove(close);
			state.remove(bg);
			super.destroy();
		}
		
	}

}