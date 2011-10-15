package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.geom.Point;
	
	public class Player extends Entity
	{
		public var dx: int = 0;
		public var dy: int = 0;
		public var newDX: int = 0;
		public var newDY: int = 0;
		
		public var fromX: int = -1;
		public var fromY: int = 0;
		
		public var segments: Array = [];
		
		public var dead: Boolean = false;
		
		public function Player()
		{
			for (var i: int = 2; i < 7; i++) {
				segments.push(new Point(i, 30));
				
				x = i;
				y = 30;
			}
		}
		
		public override function update (): void
		{
			if (dead) {
				if (Input.pressed(-1)) {
					FP.world = new Level();
				}
				
				return;
			}
			
			var connected: Boolean = false;
			var disallowUp: Boolean = false;
			
			var p: Point;
			
			for (var i: int = segments.length - 1; i >= 0; i--) {
				p = segments[i];
				
				if (Level.grid.getTile(p.x - 1, p.y)) { connected = true; break; }
				if (Level.grid.getTile(p.x + 1, p.y)) { connected = true; break; }
				if (Level.grid.getTile(p.x, p.y - 1)) { connected = true; break; }
				
				if (i == 0) {
					disallowUp = true;
					
					for each (var q: Point in segments) {
						if (p.x != q.x) {
							disallowUp = false;
							break;
						}
					}
				}
				
				if (Level.grid.getTile(p.x, p.y + 1)) { connected = true; break; }
			}
			
			var oldDX: int = dx;
			var oldDY: int = dy;
			
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
			
			if (connected) {
				if (newDX != 0 || newDY != 0) {
					dx = newDX;
					dy = newDY;
				}
				
				if (dx == 0 && dy == 0) { return; }
				
				if (Level.grid.getTile(x + dx, y + dy)) {
					if (oldDX != dx || oldDY != dy) {
						dx = oldDX; dy = oldDY;
					}
					
					if (Level.grid.getTile(x + dx, y + dy)) {
						
						var left: Boolean = Level.grid.getTile(x - oldDY, y + oldDX);
						var right: Boolean = Level.grid.getTile(x + oldDY, y - oldDX);
						
						if (left && ! right) {
							dx = oldDY;
							dy = -oldDX;
						} else if (right && ! left) {
							dx = -oldDY;
							dy = oldDX;
						} else if (left && right) {
							dx = -oldDX;
							dy = -oldDY;
						} else {
							dx = 0;
							dy = 0;
						}
					}
				} else {
					newDX = 0;
					newDY = 0;
				}
				
				if (dx == 0 && dy == 0) { return; }
				
				if (dx != 0 || dy != 0) {
					
					if (dx == 0 && dy == -1 && disallowUp) {
						return;
					}
					
					for each (p in segments) {
						if (x + dx == p.x && y + dy == p.y) {
							dead = true;
							return;
						}
					}
					
					x += dx;
					y += dy;
					
					fromX = -dx;
					fromY = -dy;
				}
				
				if (Level.bitmap.getPixel(x, y) == 0xFF0000) {
					Level.bitmap.setPixel(x, y, Level.BLANK);
					
					Level.newFood();
					
					segments.push(new Point(x, y));
				} else {
					p = segments.shift();
					p.x = x;
					p.y = y;
					
					segments.push(p);
				}
			} else {
				//dx = 0;
				//dy = 0;
				
				y += 1;
				
				if (Level.bitmap.getPixel(x, y) == 0xFF0000) {
					Level.bitmap.setPixel(x, y, Level.BLANK);
					
					Level.newFood();
					
					segments.push(new Point(x, y));
				} else {
					for each (p in segments) {
						p.y += 1;
					}
				}
				
				
			}
		}
		
		public override function render (): void
		{
			trace("Go");
			for each (var p: Point in segments) {
				var c: uint = FP.buffer.getPixel(p.x, p.y);
				
				if (c == 0xFF0000) {
					FP.buffer.setPixel(p.x, p.y, 0xDD8855);
				} else {
					FP.buffer.setPixel(p.x, p.y, 0x33AA33);
				}
				
				trace(p);
			}
			
			FP.buffer.setPixel(x, y, 0x154615);
		}
	}
}
