package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import com.increpare.bfxr.Bfxr;
	
	import flash.geom.Point;
	
	public class Player extends Entity
	{
		public var dx: int = 1;
		public var dy: int = 0;
		
		public var segments: Array = [];
		
		public var dead: Boolean = false;
		public var deadShow: int = 0;
		
		public var score:int = 0;
		
		public var eatSound:Bfxr;
		
		private static const soundData:String = "0.9744,0.5,0.0563,0.0922,,0.1543,0.2809,0.2979,,-0.3727,-0.0327,,0.0533,0.0274,,,-0.0294,0.0415,0.0029,,,-0.012,,-0.0111,0.0027,1,-0.0268,0.0322,,0.078,,0.0052,masterVolume";
		
		public var id:int;
		
		public function Player(id:int = 0)
		{
			this.id = id;
			
			for (var i: int = 2; i < 7; i++) {
				if (id == 0) {
					x = i;
				} else {
					x = FP.width - i - 1;
					dx *= -1;
				}
				
				y = FP.height*0.5;
				
				segments.push(new Point(x, y));
			}
			
			type = "player";
			
			eatSound = new Bfxr();
			eatSound.Load(soundData);
			eatSound.CacheMutations(0.05,10);
		}
		
		public override function update (): void
		{
			/*var framerate:Number = 10 + segments.length * 0.2;
			
			if (FP.stage.frameRate != framerate) {
				FP.stage.frameRate = framerate;
			}*/
			
			if (dead) {
				var full:Boolean = deadShow > segments.length;
				
				if (! full) {
					deadShow += 3;
				}
				
				return;
			}
			
			if (Level(world).gameover) {
				return;
			}
			
			var p: Point;
			
			var fromX:int = -dx;
			var fromY:int = -dy;
			
			var oldDX: int = dx;
			var oldDY: int = dy;
			
			var newDX:int = 0;
			var newDY:int = 0;
			
			var nextDir:int = Main.getNextDir(id);
			
			if (nextDir == (Key.LEFT)) {
				newDX = -1; newDY = 0;
			}
			if (nextDir == (Key.RIGHT)) {
				newDX = 1; newDY = 0;
			}
			if (nextDir == (Key.UP)) {
				newDX = 0; newDY = -1;
			}
			if (nextDir == (Key.DOWN)) {
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
			
			var players:Array = [];
			
			world.getType("player", players);
			
			for each (var player:Player in players) {
				for each (p in player.segments) {
					if (x + dx == p.x && y + dy == p.y) {
						dead = true;
						return;
					}
				}
			}
			
			x += dx;
			y += dy;
			
			var c:uint = Level.bitmap.getPixel(x, y);
			
			var myShit:int = id ? Level.SHIT2 : Level.TRAIL;
			var theirShit:int = id ? Level.TRAIL : Level.SHIT2;
			
			if (! Main.versus) {
				theirShit = myShit;
			}
			
			if (c == 0xFF0000 || c == theirShit || c == Level.FOOD) {
				score += 1;
				
				if (eatSound) eatSound.Play();
				
				Level.bitmap.setPixel(x, y, myShit);
				
				p = segments[0];
				
				Level.bitmap.setPixel(x, y, myShit);
				
				var i:int = 0;
				var j:int = 0;
				
				for (; i < 5 && j < segments.length; j++) {
					p = segments[j];
					
					c = Level.bitmap.getPixel(p.x, p.y);
					
					if (c != myShit) {
						Level.bitmap.setPixel(p.x, p.y, myShit);
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
			
			var snakeColor:int = id ? Level.SNAKE2 : Level.SNAKE;
			var headColor:int = id ? Level.HEAD2 : Level.HEAD;
			var shitColor:int = id ? Level.SHIT2 : Level.TRAIL;
			
			FP.buffer.setPixel(p.x, p.y, snakeColor);
			
			var pPrev:Point;
			
			for (var i:int = 0; i < segments.length; i++) {
				p = segments[segments.length - 1 - i];
				
				if (pPrev && pPrev.x == p.x && pPrev.y == p.y) {
					continue;
				}
				
				pPrev = p;
				
				var c: uint = FP.buffer.getPixel(p.x, p.y);
				
				FP.buffer.setPixel(p.x, p.y, deadShow > i ? shitColor : snakeColor);
			}
			
			FP.buffer.setPixel(x, y, headColor);
			
			super.render();
		}
	}
}
