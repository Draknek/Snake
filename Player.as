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
		
		[Embed(source="shitsnake.mp3")] public static const MUSIC:Class
		
		public var sfx:Sfx;
		
		public var id:int;
		
		public function Player(id:int = 0)
		{
			this.id = id;
			
			for (var i: int = 2; i < 7; i++) {
				x = i;
				y = FP.height*0.5;
				
				segments.push(new Point(x, y));
			}
			
			type = "player";
			
			eatSound = new Bfxr();
			eatSound.Load(soundData);
			eatSound.CacheMutations(0.05,10);
			
			sfx = new Sfx(MUSIC);
			
			sfx.loop();
		}
		
		public override function update (): void
		{
			/*var framerate:Number = 10 + segments.length * 0.2;
			
			if (FP.stage.frameRate != framerate) {
				FP.stage.frameRate = framerate;
			}*/
			
			if (dead) {
				var full:Boolean = deadShow > segments.length;
				if (Input.pressed(Key.SPACE)) {
					FP.world = new Level();
				}
				
				var best:int = Level.so.data.highscore;
				
				var text:Text;
				
				if (! graphic) {
					sfx.stop();
					
					var bestText:String = "Best: " + best;
					
					if (score > best) {
						best = score;
						
						bestText = "New best!";
						
						Level.so.data.highscore = best;
						
						Level.so.flush();
					}
					
					text = new Text("Score: " + score + "\n" + bestText  + "\nHit space", 1, 1, {align:"center", size:8, width: FP.width, height: FP.height});
					
					text.relative = false;
					
					graphic = text;
				}
				
				if (full) {
				} else {
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
			
			if (c == 0xFF0000 || c == Level.TRAIL || (Level.food.x == x && Level.food.y == y)) {
				score += 1;
				
				if (eatSound) eatSound.Play();
				
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
			
			super.render();
		}
	}
}
