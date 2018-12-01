package game;

class Factory {
    static public var tileMap:phaser.Tilemap;

    static public function init(game:phaser.Game) {
        tileMap = game.add.tilemap('bg');
        tileMap.addTilesetImage('sheet', 'sheet');
    }

}
