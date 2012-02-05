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
		public var buttons:Array = [];
		
		public function Menu ()
		{
			Text.size = 8;
			Text.align = "center";
			
			var bg: BitmapData = new BitmapData(FP.width, FP.height, false, Level.SOLID);
			
			var rect: Rectangle = new Rectangle(1, 1, FP.width - 2, FP.height - 2);
			
			bg.fillRect(rect, Level.BLANK);
			
			addGraphic(new Stamp(bg));
			
			var title:Text = new Text("Shit Snake", 0, 1, {color: Level.TRAIL, width: FP.width, leading: 0});
			
			addGraphic(title);
			
			//add(new Button("By Alan H", 10, makeURLFunction("http://www.draknek.org/?ref=shitsnake"), Level.SNAKE, Level.HEAD));
			
			makeButton("1 Player", function ():void { Main.versus = false; FP.world = new Level; });
			
			makeButton("2 Player", function ():void { Main.versus = true; FP.world = new Level; });
			
			var start:int = title.y + title.height;
			
			var padding:int = FP.height - start;
			
			for each (var b:Button in buttons) {
				padding -= b.height;
			}
			
			start += (padding % (buttons.length + 1));
			
			padding /= (buttons.length + 1);
			
			for each (b in buttons) {
				b.y = start;
				start += padding + b.height;
			}
		}
		
		public override function update ():void
		{
			if (Input.pressed(Key.SPACE) || Input.pressed(Key.ENTER)) {
				FP.world = new Level;
			}
			
			super.update();
		}
		
		private function makeButton (t:String, f:Function): Button
		{
			var b:Button = new Button(t, 20, f, 0xFFFFFF, Level.TRAIL);
			
			add(b);
			
			buttons.push(b);
			
			return b;
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
