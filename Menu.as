package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.net.*;
	
	public class Menu extends World
	{
		public function Menu ()
		{
			Text.size = 8;
			Text.align = "center";
			
			var bg: BitmapData = new BitmapData(FP.width, FP.height, false, Level.SOLID);
			
			var rect: Rectangle = new Rectangle(1, 1, FP.width - 2, FP.height - 2);
			
			bg.fillRect(rect, Level.BLANK);
			
			addGraphic(new Stamp(bg));
			
			addGraphic(new Text("Shit Snake", 0, 1, {color: Level.TRAIL, width: FP.width}));
			
			//add(new Button("By Alan H", 10, makeURLFunction("http://www.draknek.org/?ref=shitsnake"), Level.SNAKE, Level.HEAD));
			
			add(new Button("Start", 20, function ():void { FP.world = new Level; }, 0xFFFFFF, Level.TRAIL));
		}
		
		public override function update ():void
		{
			if (Input.pressed(Key.SPACE) || Input.pressed(Key.ENTER)) {
				FP.world = new Level;
			}
			
			super.update();
		}
		
		private function makeURLFunction (url:String): Function
		{
			return function ():void {
				var request:URLRequest = new URLRequest(url);
				navigateToURL(request, "_blank");
			}
		}
		
	}
}
