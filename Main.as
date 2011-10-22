package
{
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	
	import flash.events.*;
	
	[SWF(width = "480", height = "320", backgroundColor="#000000")]
	public class Main extends Engine
	{
		public function Main() 
		{
			super(48, 32, 15, true);
			FP.world = new Menu();
			FP.screen.color = 0xFFFFFF;
			scaleX = 10;
			scaleY = 10;
		}
		
		public override function init ():void
		{
			FP.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public override function update ():void
		{
			super.update();
			
			nextDir = queueDir;
			queueDir = 0;
		}
		
		public static var nextDir:int = 0;
		public static var queueDir:int = 0;
		
		private static function onKeyDown (e:KeyboardEvent):void
		{
			var code:int = e.keyCode;
			
			if (code >= Key.LEFT && code <= Key.DOWN) {
				if (! nextDir) {
					nextDir = code;
				} else if (! queueDir) {
					queueDir = code;
				}
			}
		}
	}
}

