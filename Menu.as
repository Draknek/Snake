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
			addGraphic(new Stamp(MENU));
		}
		
		public override function update ():void
		{
			if (Input.pressed(Key.SPACE)) {
				FP.world = new Level;
			}
		}
	}
}
