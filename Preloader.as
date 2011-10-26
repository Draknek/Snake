
package
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.getDefinitionByName;

	[SWF(width = "480", height = "320", backgroundColor="#000000")]
	public class Preloader extends Sprite
	{
		// Change these values
		private static const mustClick: Boolean = false;
		private static const mainClassName: String = "Main";
		
		private static const BORDER_COLOR:uint = 0x265f49;
		private static const BG_COLOR:uint = 0x68a941;
		private static const FG_COLOR:uint = 0x389218;
		
		
		
		// Ignore everything else
		
		
		
		private var progressBar: Shape;
		private var text: TextField;
		
		private var px:int;
		private var py:int;
		private var w:int;
		private var h:int;
		private var sw:int;
		private var sh:int;
		
		[Embed(source = 'net/flashpunk/graphics/04B_03__.TTF', fontFamily = 'default')]
		private static const FONT:Class;
		
		public function Preloader ()
		{
			sw = stage.stageWidth;
			sh = stage.stageHeight;
			
			w = stage.stageWidth * 0.8;
			h = 20;
			
			px = (sw - w) * 0.5;
			py = (sh - h) * 0.5;
			
			graphics.beginFill(BORDER_COLOR);
			graphics.drawRect(0, 0, sw, sh);
			graphics.endFill();
			
			graphics.beginFill(BG_COLOR);
			graphics.drawRect(10, 10, sw-20, sh-20);
			graphics.endFill();
			
			graphics.beginFill(FG_COLOR);
			graphics.drawRect(px - 10, py - 10, w + 20, h + 20);
			graphics.endFill();
			
			progressBar = new Shape();
			
			addChild(progressBar);
			
			text = new TextField();
			
			text.textColor = FG_COLOR;
			text.selectable = false;
			text.mouseEnabled = false;
			var format:TextFormat = new TextFormat("default", 8);
			format.align = "center";
			text.defaultTextFormat = format;
			text.embedFonts = true;
			text.autoSize = "center";
			text.text = "0%";
			text.x = uint((sw - text.width) * 0.5);
			text.y = uint(sh * 0.5 + h);
			text.scaleX = 10.0;
			text.scaleY = 10.0;
			
			addChild(text);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (mustClick) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}

		public function onEnterFrame (e:Event): void
		{
			if (hasLoaded())
			{
				graphics.clear();
				graphics.beginFill(BG_COLOR);
				graphics.drawRect(0, 0, sw, sh);
				graphics.endFill();
				
				if (! mustClick) {
					startup();
				} else {
					text.text = "Make click\nfor play";
			
					text.y = uint((sh - text.height) * 0.5);
				}
			} else {
				var p:Number = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal);
				
				progressBar.graphics.clear();
				progressBar.graphics.beginFill(BG_COLOR);
				progressBar.graphics.drawRect(px, py, p * w, h);
				progressBar.graphics.endFill();
				
				text.text = int(p * 100) + "%";
			}
			
			text.x = uint((sw - text.width) * 0.5);
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if (hasLoaded())
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				startup();
			}
		}
		
		private function hasLoaded (): Boolean {
			return (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal);
		}
		
		private function startup (): void {
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var mainClass:Class = getDefinitionByName(mainClassName) as Class;
			parent.addChild(new mainClass as DisplayObject);
			
			parent.removeChild(this);
		}
	}
}


