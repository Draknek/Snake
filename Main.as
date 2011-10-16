package
{
	import net.flashpunk.*;
	
	[SWF(width = "480", height = "320", backgroundColor="#000000")]
	public class Main extends Engine
	{
		public function Main() 
		{
			super(48, 32, 15, true);
			FP.world = new Menu();
			FP.screen.color = 0xFFFFFF;
			scaleX = 10;
			scaleY = 10;
		}
	}
}

