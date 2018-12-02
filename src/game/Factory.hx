package game;

import ash.core.Entity;
import whiplash.phaser.*;

class Factory {
    static public var tileMap:phaser.Tilemap;

    static public function preload(game:phaser.Game) {
        game.load.image("super-mario", "../data/textures/super-mario.png");
        game.load.image("sky", "../data/textures/blue-sky.png");
        game.load.tilemap("level", cast "../data/tilemaps/level.json", cast null, cast phaser.Tilemap.TILED_JSON);
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
        return e;
    }

    static public function createLevel() {
        var e = new Entity();
        e.add(new TilemapLayer(tileMap, 0, 640, 480));
        return e;
    }

    static public function createPlayer() {
        var e = new Entity();
        var sprite = new Sprite("mario-sprites");
        e.add(sprite);
        e.add(new Transform());
        e.get(Transform).position.y = 0;
        e.get(Transform).position.x = 16;
        sprite.animations.add("idle", ["mario/stand"]);
        sprite.animations.add("walk", [for(i in 1...4) "mario/walk" + i]);
        sprite.animations.play('walk', 15, true);
        return e;
    }
}
