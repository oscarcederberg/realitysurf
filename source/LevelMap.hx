package;

import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.tile.FlxTilemap;

class LevelMap
{
	var map:FlxOgmo3Loader;
	var tilemap:FlxTilemap;

	public var player:Player;
	public var tiles:FlxTypedSpriteGroup<Tile>;

	public function new(file:String)
	{
		this.map = new FlxOgmo3Loader("assets/data/REALITYSURF.ogmo", "assets/data/" + file);
		this.tilemap = map.loadTilemap("assets/data/OGMO/tiles.png", "tiles");

		this.tiles = new FlxTypedSpriteGroup<Tile>();

		placeTiles();
		this.map.loadEntities(placeEntities, "entities");
	}

	public function placeTiles()
	{
		var width = tilemap.widthInTiles;
		var height = tilemap.heightInTiles;
		for (x in 0...width)
		{
			for (y in 0...height)
			{
				var index:Int = tilemap.getData()[y * width + x];
				var real_x = x * Global.CELL_SIZE;
				var real_y = y * Global.CELL_SIZE;
				switch (index)
				{
					case 1:
						tiles.add(new Tile(real_x, real_y));
				}
			}
		}
	}

	public function placeEntities(entity:EntityData)
	{
		var real_x = entity.x;
		var real_y = entity.y;
		switch (entity.name)
		{
			case "player":
				player = new Player(real_x, real_y);
		}
	}
}
