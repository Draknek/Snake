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
		[Embed(source="camosnake-menu.png")] public static const MENU: Class;
		
		public function Menu ()
		{
			Text.size = 8;
			Text.align = "center";
			
			addGraphic(new Stamp(MENU));
			
			//addGraphic(new Text("Camouflage\nSnake", 0, -1, {color: Level.HEAD, width: FP.width, leading: -1}));
			
			add(new Button("By Alan H", 13, makeURLFunction("http://www.draknek.org/?ref=camosnake"), Level.SNAKE, Level.HEAD));
			
			add(new Button("Start", 22, function ():void { FP.world = new Level; }, 0xFFFFFF, Level.HEAD));
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
