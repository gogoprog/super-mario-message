package game;

import ash.core.Entity;
import whiplash.phaser.*;

class Factory {
    static public var tileMap:phaser.Tilemap;

    static public function preload(game:phaser.Game) {
        game.load.image("super-mario", "../data/textures/super-mario.png");
        game.load.image("sky", "../data/textures/blue-sky.png");
        game.load.tilemap("level", cast "../data/tilemaps/level.json", cast null, cast phaser.Tilemap.TILED_JSON);
        game.load.spritesheet('mario', '../data/textures/mario-sprites.png', 16, 32);
        game.load.atlas('mario-sprites', '../data/textures/mario-sprites.png', '../data/textures/mario-sprites.json');
    }

    static public function init(game:phaser.Game) {
        tileMap = game.add.tilemap('level');
        tileMap.addTilesetImage('super-mario', 'super-mario');
    }

    static public function createSky() {
        var e = new Entity();
        e.add(new Sprite("sky"));
        e.add(new Transform());
        e.get(Transform).position.y = 200;
        return e;
    }
    static public function createLevel() {
        var e = new Entity();
        e.add(new TilemapLayer(tileMap, 0, 640, 480));
        return e;
    }
}
