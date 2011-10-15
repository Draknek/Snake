package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.geom.Point;
	
	public class Player extends Entity
	{
		public var dx: int = 1;
		public var dy: int = 0;
		
		public var segments: Array = [];
		
		public var dead: Boolean = false;
		public var deadShow: int = 0;
		
		public var score:int = 0;
		
		public function Player()
		{
			for (var i: int = 2; i < 7; i++) {
				x = i;
				y = FP.height*0.5;
				
				segments.push(new Point(x, y));
			}
		}
		
		public override function update (): void
		{
			/*var framerate:Number = 10 + segments.length * 0.2;
			
			if (FP.stage.frameRate != framerate) {
				FP.stage.frameRate = framerate;
			}*/
			
			if (dead) {
				var full:Boolean = deadShow > segments.length;
				if (Input.pressed(-1) && full) {
					FP.world = new Level();
				}
				
				if (! full) {
					deadShow += 3;
				}
				
				return;
			}
			
			var p: Point;
			
			var fromX:int = -dx;
			var fromY:int = -dy;
			
			var oldDX: int = dx;
			var oldDY: int = dy;
			
			var newDX:int = 0;
			var newDY:int = 0;
			
			if (Input.pressed(Key.LEFT)) {
				newDX = -1; newDY = 0;
			}
			if (Input.pressed(Key.RIGHT)) {
				newDX = 1; newDY = 0;
			}
			if (Input.pressed(Key.UP)) {
				newDX = 0; newDY = -1;
			}
			if (Input.pressed(Key.DOWN)) {
				newDX = 0; newDY = 1;
			}
			
			if (newDX == fromX && newDY == fromY) {
				newDX = 0;
				newDY = 0;
			}
			
			/**
			
			Okay, at this point we have four dx/dy pairs:
			dx/dy
			oldDX/DY = dx/dy from last frame
			newDX/DY = direction we've indicated we want to go in
			fromX/fromY = inverse of oldDX/DY?
			
			*/
			
			if (newDX != 0 || newDY != 0) {
				dx = newDX;
				dy = newDY;
			}

			if (dx == 0 && dy == 0) { return; }
			
			if (Level.grid.getTile(x + dx, y + dy)) {
				if (Level.grid.getTile(x + dx, y + dy)) {
					dead = true;
					return;
				}
			}
			
			newDX = 0;
			newDY = 0;
			
			if (dx == 0 && dy == 0) { return; }
			
			for each (p in segments) {
				if (x + dx == p.x && y + dy == p.y) {
					dead = true;
					return;
				}
			}
			
			x += dx;
			y += dy;
			
			var c:uint = Level.bitmap.getPixel(x, y);
			
			if (c == 0xFF0000 || c == Level.TRAIL || (Level.food.x == x && Level.food.y == y)) {
				score += 1;
				
				Level.bitmap.setPixel(x, y, Level.BLANK);
				
				//Level.newFood();
				
				p = segments[0];
				
				//Level.bitmap.setPixel(p.x, p.y, Level.TRAIL);
			
				Level.bitmap.setPixel(x, y, Level.BLANK);
				
				Level.food.x = Level.food.y = -2;
				
				var i:int = 0;
				var j:int = 0;
				
				for (; i < 5 && j < segments.length; j++) {
					p = segments[j];
					
					c = Level.bitmap.getPixel(p.x, p.y);
					
					if (c != Level.TRAIL) {
						Level.bitmap.setPixel(p.x, p.y, Level.TRAIL);
						i++;
					}
				}
				
				p = segments[0];
				
				for (i = 0; i < 2; i++) {
					segments.unshift(new Point(p.x, p.y));
				}
				
			}
			
			p = segments.shift();
			p.x = x;
			p.y = y;
			
			segments.push(p);
			
			p = segments[0];
		}
		
		public override function render (): void
		{
			var p: Point = segments[0];
			
			FP.buffer.setPixel(p.x, p.y, Level.SNAKE);
			
			for (var i:int = 0; i < segments.length; i++) {
				
				if (deadShow <= i) {
					//break;
				}
				
				p = segments[segments.length - 1 - i];
				
				var c: uint = FP.buffer.getPixel(p.x, p.y);
				
				FP.buffer.setPixel(p.x, p.y, deadShow <= i ? Level.TRAIL : Level.SNAKE);
				
				FP.buffer.setPixel(p.x, p.y, deadShow > i ? Level.TRAIL : Level.SNAKE);
			}
			
			p = segments[0];
			
			//FP.buffer.setPixel(p.x, p.y, Level.SNAKE);
			
			FP.buffer.setPixel(x, y, Level.HEAD);
		}
	}
}
