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
		public static const SHIT2: uint = 0x9c6a2b;
		
		public static const so:SharedObject = SharedObject.getLocal(gameID, "/");
		
		public static const gameID:String = "shitsnake";
		
		public var gameover:Boolean = false;
		public var hasWinner:Boolean = false;
		
		public var players:Array = [];
		
		[Embed(source="shitsnake.mp3")] public static const MUSIC:Class
		
		public var music:Sfx;
		
		public function Level()
		{}
		
		public override function begin (): void
		{
			var level: BitmapData = bitmap = new BitmapData(FP.width, FP.height, false, 0x000000);
			
			var rect: Rectangle = new Rectangle(1, 1, FP.width - 2, FP.height - 2);
			
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
		
		private var gameOverText:Text;
		
		public function addGameOverText (): void
		{
			var message:String;
			
			if (! Main.versus) {
				var score:int = players[0].score;
			
				var best:int = Level.so.data.highscore;
			
				var bestText:String = "Best: " + best;
			
				if (score > best) {
					best = score;
				
					bestText = "New best!";
				
					Level.so.data.highscore = best;
				
					Level.so.flush();
				}
				
				message = "Score: " + score + "\n" + bestText;
				
				message += "\nHit space";
			} else {
				var p1:Player = players[0];
				var p2:Player = players[1];
				
				if (p1.dead && p2.dead) {
					message = "Draw!"
				} else if (p1.dead) {
					message = "Right wins!";
					Main.scores[1]++;
				} else {
					message = "Left wins!";
					Main.scores[0]++;
				}
				
				var leftString:String = "" + Main.scores[0];
				var rightString:String = "" + Main.scores[1];
				
				while (leftString.length < rightString.length) {
					leftString = " " + leftString;
				}
				
				while (leftString.length > rightString.length) {
					rightString = rightString + " ";
				}
				
				if (Main.scores[0] >= Main.targetScore || Main.scores[1] >= Main.targetScore) {
					message = "Final score\n" + leftString + " - " + rightString + "\n" + message;
					hasWinner = true;
				} else {
					message += "\n" + leftString + " - " + rightString + "\nHit space";
				}
			}
			
			gameOverText = new Text(message, Main.versus ? 0 : 1, 1, {align:"center", size:8, width: FP.width});
			
			gameOverText.x = int((FP.width - gameOverText.width) * 0.5);
			gameOverText.y = int((FP.height - gameOverText.height) * 0.5);
			
			if (Text.font == "default" && gameOverText.x >= 0) {
				gameOverText.x += 1;
			}
			
			gameOverText.relative = false;
			
			gameOverText.alpha = 0;
			
			addGraphic(gameOverText);
			
			FP.alarm(15, function ():void { gameOverText.alpha = 1; });
		}
		
		public override function update (): void
		{
			super.update();
			
			if (! gameover) {
				for each (var p:Player in players) {
					if (p.dead) {
						gameover = true;
						music.stop();
						
						addGameOverText();
						
						break;
					}
				}
			}
			
			if (gameover) {
				if (Input.pressed(Key.SPACE)) {
					if (gameOverText.alpha < 0.9) {
						gameOverText.alpha = 1;
					} else {
						if (hasWinner) {
							var parts:Array = gameOverText.text.split("\n");
							
							if (parts[0] != parts[2]) {
								parts[0] = parts[2];
								gameOverText.text = parts.join("\n");
							} else if (parts[1] != parts[2]) {
								parts[1] = parts[2];
								gameOverText.text = parts.join("\n");
							} else {
								FP.world = new Menu();
							}
							
							return;
						}
						
						FP.world = new Level();
					}
				}
			}
			
			if (Input.pressed(Key.ESCAPE)) {
				music.stop();
				FP.world = new Menu;
			}
		}
		
		public override function render (): void
		{
			super.render();
		}
	}
}
