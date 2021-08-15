import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import haxe.ds.GenericStack;

class FileWindowHandler
{
	public var random:FlxRandom;
	public var windows:FlxTypedSpriteGroup<FileWindow>;
	public var stack:GenericStack<FileWindow>;

	public function new()
	{
		this.random = new FlxRandom();
		this.windows = new FlxTypedSpriteGroup<FileWindow>();
		this.stack = new GenericStack<FileWindow>();
		this.windows.scrollFactor.set(0, 0);
	}

	public function update(elapsed:Float):Void
	{
		var _click:Bool = FlxG.mouse.justPressed;
		var _mouse_point:FlxPoint = FlxG.mouse.getPositionInCameraView();

		if (_click)
		{
			for (window in stack)
			{
				var hitboxWindow:FlxObject = window.hitboxWindow;
				var hitboxBar:FlxObject = window.hitboxBar;
				var hitboxClose:FlxObject = window.hitboxClose;

				if (hitboxWindow.overlapsPoint(_mouse_point))
				{
					if (hitboxClose.overlapsPoint(_mouse_point))
					{
						deleteWindow(window);
						break;
					}
					else if (hitboxBar.overlapsPoint(_mouse_point))
					{
						window.activateDragging();
						if (!isWindowActive(window))
							setWindowAsActive(window);
						break;
					}
					else
					{
						if (!isWindowActive(window))
							setWindowAsActive(window);
						break;
					}
				}
			}
		}
	}

	public function sortWindows():Void
	{
		var index:Int = 0;
		for (window in stack)
		{
			window.depth = index;
			index++;
		}

		windows.members.sort(function(w1, w2) return w2.depth - w1.depth);
	}

	public function createWindow(file:File):Void
	{
		var windowWidth:Int = random.int(1, 8);
		var windowHeight:Int = random.int(1, 8);
		var windowX:Int = random.int(0, FlxG.width - Global.CELL_SIZE * (windowWidth + 2) + (FileWindow.OFFSET_SIDE * 2));
		var windowY:Int = random.int(Global.CELL_SIZE,
			FlxG.height - Global.CELL_SIZE * (windowHeight + 2) - (FileWindow.OFFSET_TOP + FileWindow.OFFSET_BOTTOM));

		var window:FileWindow = new FileWindow(windowX, windowY, windowWidth, windowHeight, this);
		windows.add(window);
		stack.add(window);

		sortWindows();
	}

	public function deleteWindow(window:FileWindow)
	{
		stack.remove(window);
		window.kill();

		sortWindows();
	}

	public function setWindowAsActive(window:FileWindow)
	{
		stack.remove(window);
		stack.add(window);

		sortWindows();
	}

	public function isWindowActive(window:FileWindow):Bool
	{
		return stack.first() == window;
	}
}
