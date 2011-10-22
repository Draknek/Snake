package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Button extends Entity
	{
		public var image:Image;
		
		public var callback:Function;
		
		public var normalColor:uint = 0xFFFFFF;
		public var hoverColor:uint = 0xFF0000;
		
		public function Button (text:String, _y:int, _callback:Function, c1:uint, c2:uint)
		{
			y = _y;
			
			normalColor = c1;
			hoverColor = c2;
			
			image = new Text(text);
			
			image.color = normalColor;
			
			graphic = image;
			
			setHitbox(image.width - 3, image.height - 5, -1, -2);
			
			type = "button";
			
			callback = _callback;
			
			x = (FP.width - image.width) * 0.5;
		}
		
		public override function update (): void
		{
			if (!world) return;
			
			var over:Boolean = collidePoint(x, y, world.mouseX, world.mouseY);
			
			if (over) {
				Input.mouseCursor = "button";
			}
			
			image.color = (over) ? hoverColor : normalColor;
			
			/*if (over && Input.mousePressed && callback != null) {
				callback();
			}*/
		}
	}
}

