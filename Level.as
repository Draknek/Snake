package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	import flash.geom.*;
	
	public class Level extends World
	{
		public var player: Player;
		
		public static var grid: Grid;
		public static var bitmap: BitmapData;
		
		public static const BLANK: uint = 0x46c1e5;
		public static const SOLID: uint = 0x8a4216;
		
		public function Level()
		{}
		
		public override function begin (): void
		{
			var level: BitmapData = bitmap = new BitmapData(48, 32, false, 0x000000);
			
			var rect: Rectangle = new Rectangle(1, 1, 46, 30);
			
			level.fillRect(rect, 0xFFFFFF);
			
			rect.height = 1;
			
			rect.x = Math.random() * 5 + 5;
			rect.width = Math.random() * 12 + 8;
			rect.y = Math.random() * 10 + 5;
			level.fillRect(rect, 0x000000);
			
			rect.x = Math.random() * 5 + 17;
			rect.width = Math.random() * 13 + 8;
			rect.y = Math.random() * 10 + 17;
			level.fillRect(rect, 0x000000);
			
			var solid: Entity = new Entity();
			
			add(solid);
			
			solid.type = "solid";
			
			solid.graphic = new Stamp(level);
			
			grid = new Grid(level.width, level.height, 1, 1);
			
			solid.mask = grid;
			
			player = new Player();
			
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
			
			newFood();
			
			add(player);
		}
		
		public static function newFood (): void
		{
			while (true) {
				var x: int = Math.random() * 48;
				var y: int = Math.random() * 32;
				
				if (bitmap.getPixel(x, y) == BLANK) {
					bitmap.setPixel(x, y, 0xFF0000);
					return;
				}
			}
		}
	}
}
