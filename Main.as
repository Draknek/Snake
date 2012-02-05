package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	
	import flash.events.*;
	import flash.display.*;
	import flash.utils.*;
	
	public class Main extends Engine
	{
		public static var touchscreen:Boolean = false;
		public static var fullscreen:Boolean = true;
		
		public static var versus:Boolean = true;
		public static var flipped:Boolean = true;
		
		public static var scores:Array = [0, 0];
		
		public static var targetScore:int = 10;
		
		[Embed(source = '7x5.ttf', embedAsCFF="false", fontFamily = '7x5')]
		public static const FONT_7x5:Class;
		
		public function Main() 
		{
			var w:int;
			var h:int;
			
			var scale:int = 10;
			
			if (touchscreen) {
				fullscreen = true;
			}
			
			if (fullscreen) {
				scale = 16;
				
				Text.font = "7x5";
				
				Text.defaultLeading = 5;
				
				try {
					Preloader.stage.displayState = StageDisplayState.FULL_SCREEN;
				} catch (e:Error) {}
				
				w = Preloader.stage.fullScreenWidth;
				h = Preloader.stage.fullScreenHeight;
			} else {
				w = Preloader.stage.stageWidth;
				h = Preloader.stage.stageHeight;
			}
			
			w = Math.floor(w / scale);
			h = Math.floor(h / scale);
			
			super(w, h, 20, true);
			FP.world = new Menu();
			FP.screen.color = 0xFFFFFF;
			FP.screen.scale = scale;
			
			if (fullscreen) {
				x = (Preloader.stage.fullScreenWidth - w * scale) * 0.5;
				y = (Preloader.stage.fullScreenHeight - h * scale) * 0.5;
			}
			
			//FP.console.enable();
		}
		
		public override function setStageProperties():void
		{
			stage.frameRate = FP.assignedFrameRate;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			if (! fullscreen) {
				stage.displayState = StageDisplayState.NORMAL;
			}
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
			
			for each (var q:Array in dirQueues) {
				q.shift();
			}
		}
		
		public static function getNextDir (id:int):int
		{
			var q:Array = dirQueues[id];
			
			if (q && q.length) return q[0];
			else return 0;
		}
		
		public static var dirQueues:Array = [];
		
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
		
		private static function addDir (code:int, player:int = 0): void
		{
			var q:Array = dirQueues[player];
			
			if (! q) {
				q = [];
				dirQueues[player] = q;
			}
			
			if (q.length <= 3) {
				q.push(code);
			}
		}
		
		private static function onKeyDown (e:KeyboardEvent):void
		{
			var code:int = e.keyCode;
			
			var arrowPlayer:int = 0;
			var wasdPlayer:int = 1;
			
			if (flipped) {
				arrowPlayer = 1;
				wasdPlayer = 0;
			}
			
			if (! versus) {
				arrowPlayer = wasdPlayer = 0;
			}
			
			if (code >= Key.LEFT && code <= Key.DOWN) {
				addDir(code, arrowPlayer);
				return;
			}
			
			if (code == Key.W) {
				addDir(Key.UP, wasdPlayer);
			} else if (code == Key.S) {
				addDir(Key.DOWN, wasdPlayer);
			} else if (code == Key.A) {
				addDir(Key.LEFT, wasdPlayer);
			} else if (code == Key.D) {
				addDir(Key.RIGHT, wasdPlayer);
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

