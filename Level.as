package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.net.*;
	
	public class Level extends World
	{
		public static var grid: Grid;
		public static var bitmap: BitmapData;
		
		public static const BLANK: uint = 0x68a941;
		public static const SOLID: uint = 0x265f49;
		public static const TRAIL: uint = 0x8a520c;
		public static const FOOD: uint = 0xff0000;
		public static const SNAKE: uint = 0xf4e46a;
		public static const HEAD: uint = 0xd97d3c;
		public static const SNAKE2: uint = 0xd97d3c;
		public static const HEAD2: uint = 0xf4e46a;
		
		public static const so:SharedObject = SharedObject.getLocal(gameID, "/");
		
		public static const gameID:String = "shitsnake";
		
		public var gameover:Boolean = false;
		
		public var players:Array = [];
		
		[Embed(source="shitsnake.mp3")] public static const MUSIC:Class
		
		public var music:Sfx;
		
		public function Level()
		{}
		
		public override function begin (): void
		{
			var level: BitmapData = bitmap = new BitmapData(48, 32, false, 0x000000);
			
			var rect: Rectangle = new Rectangle(1, 1, 46, 30);
			
			level.fillRect(rect, 0xFFFFFF);
			
			/*rect.height = 1;
			
			rect.x = Math.random() * 5 + 5;
			rect.width = Math.random() * 12 + 8;
			rect.y = Math.random() * 10 + 5;
			level.fillRect(rect, 0x000000);
			
			rect.x = Math.random() * 5 + 17;
			rect.width = Math.random() * 13 + 8;
			rect.y = Math.random() * 10 + 17;
			level.fillRect(rect, 0x000000);*/
			
			var solid: Entity = new Entity();
			
			add(solid);
			
			solid.type = "solid";
			
			solid.graphic = new Stamp(level);
			
			grid = new Grid(level.width, level.height, 1, 1);
			
			solid.mask = grid;
			
			for (var y: int = 0; y < level.height; y++) {
				for (var x: int = 0; x < level.width; x++) {
					var colour: uint = 0x00FFFFFF & level.getPixel(x, y);
					
					//level.setPixel(x, y, BLANK);
					
					if (colour == 0x0) {
						grid.setTile(x, y, true);
						level.setPixel(x, y, SOLID);
					}
					else if (colour == 0x0000FF) {
						level.setPixel(x, y, BLANK);
					}
					else if (colour == 0xFFFFFF) {
						level.setPixel(x, y, BLANK);
					}
				}
			}
			
			var playerCount:int = Main.versus ? 2 : 1;
			
			for (var i:int = 0; i < playerCount; i++) {
				var player:Player = new Player(i);
			
				add(player);
				
				players.push(player);
				
				newFood();
			}
			
			if (Main.versus && FP.rand(4) == 0) {
				newFood();
			}
			
			music = new Sfx(MUSIC);
			
			music.loop();
		}
		
		public static function newFood (): void
		{
			var minX:int = 2;
			var minY:int = 2;
			
			var spanX:int = bitmap.width - minX*2;
			var spanY:int = bitmap.height - minY*2;
			while (true) {
				var x: int = minX + Math.random() * spanX;
				var y: int = minY + Math.random() * spanY;
				
				{//if (bitmap.getPixel(x, y) == BLANK) {
					bitmap.setPixel(x, y, FOOD);
					return;
				}
			}
		}
		
		public override function update (): void
		{
			super.update();
			
			if (! gameover) {
				for each (var p:Player in players) {
					if (p.dead) {
						gameover = true;
						music.stop();
						break;
					}
				}
			}
		}
		
		public override function render (): void
		{
			super.render();
		}
	}
}
