package
{
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	
	import flash.events.*;
	import flash.display.*;
	import flash.utils.*;
	
	[SWF(width = "480", height = "320", backgroundColor="#000000")]
	public class Main extends Engine
	{
		public static var touchscreen:Boolean = false;
		
		public function Main() 
		{
			var w:int;
			var h:int;
			
			var targetW:int = 48;
			var targetH:int = 32;
			
			var scale:int = 10;
			
			if (touchscreen) {
				try {
					Preloader.stage.displayState = StageDisplayState.FULL_SCREEN;
				} catch (e:Error) {}
				
				w = Preloader.stage.fullScreenWidth;
				h = Preloader.stage.fullScreenHeight;
			} else {
				w = Preloader.stage.stageWidth;
				h = Preloader.stage.stageHeight;
			}
			
			var sizeX:Number = w / targetW;
			var sizeY:Number = h / targetH;
		
			if (sizeX > sizeY) {
				scale = int(sizeY);
			} else {
				scale = int(sizeX);
			}
	
			w = Math.floor(w / scale);
			h = Math.floor(h / scale);
			
			super(w, h, 20, true);
			FP.world = new Menu();
			FP.screen.color = 0xFFFFFF;
			FP.screen.scale = scale;
			
			//FP.console.enable();
		}
		
		public override function init ():void
		{
			if (touchscreen) {
				try {
					FP.log("init");
					var Multitouch:Class = getDefinitionByName("flash.ui.Multitouch") as Class;
					var MultitouchInputMode:Class = getDefinitionByName("flash.ui.MultitouchInputMode") as Class;
					Multitouch.inputMode = MultitouchInputMode.GESTURE;
				
					var TransformGestureEvent:Class = getDefinitionByName("flash.events.TransformGestureEvent") as Class;
					this.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipe);
				} catch (e:Error) {FP.log(e);}
			}
			
			FP.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			FP.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public override function update ():void
		{
			Input.mouseCursor = "auto";
			
			super.update();
			
			nextDir = queueDir;
			queueDir = 0;
		}
		
		public static function getNextDir (id:int):int
		{
			return nextDir;
		}
		
		public static var nextDir:int = 0;
		public static var queueDir:int = 0;
		
		private static function onSwipe(e:*):void {
			FP.log("swipe");
			
			try {
				var code:int = 0;
			
				if (e.offsetX == 1 ) {
					code = Key.RIGHT;
				} else if (e.offsetX == -1) {
					code = Key.LEFT;
				} else if (e.offsetY == -1) {
					code = Key.UP;
				} else if (e.offsetY == 1) {
					code = Key.DOWN;
				}
			
				if (code != 0) {
					addDir(code);
				}
			} catch (error:Error) {
				FP.log(error);
			}
		}
		
		private static function addDir (code:int): void
		{
			if (! nextDir) {
				nextDir = code;
			} else if (! queueDir) {
				queueDir = code;
			}
		}
		
		private static function onKeyDown (e:KeyboardEvent):void
		{
			var code:int = e.keyCode;
			
			if (code >= Key.LEFT && code <= Key.DOWN) {
				addDir(code);
			}
		}
		
		private static function onMouseDown (e:MouseEvent):void
		{
			var b:Button = FP.world.collidePoint("button", FP.screen.mouseX, FP.screen.mouseY) as Button;
			
			if (b) {
				b.callback();
			}
		}
	}
}

