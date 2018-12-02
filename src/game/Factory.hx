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
        game.load.spritesheet('level-sheet', '../data/textures/super-mario.png', 16, 16, 128, 1, 2);
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

    static public function createLetterBlock(letter) {
        var e = new Entity();
        e.add(new Transform());
        e.add(new Sprite("level-sheet", 43));
        e.add(new Text(letter));
        var text = e.get(Text);
        text.anchor.set(0, 0);
        text.align = 'center';
        text.font = 'Arial Black';
        text.fontSize = 12;
        text.fontWeight = 'bold';
        text.stroke = '#000000';
        text.strokeThickness = 2;
        text.fill = 'white';
        text.addStrokeColor('#000000', 0);
        return e;
    }

    static public function createQuestionBlock() {
        var e = new Entity();
        e.add(new Transform());
        e.add(new Sprite("level-sheet", 13));
        return e;
    }

    static public function createBlocks(input:String) {
        var result = new Array<Entity>();
        var lines = input.split("\n");
        var i = lines.length - 1;
        while(i >= 0) {
            var p = lines.length - i - 1;
            var x = Config.firstCol * Config.blockSize;
            var y = (Config.height - Config.firstRow) * Config.blockSize - p * Config.lineSpacing * Config.blockSize;
            var advance = 0;
            var isHidden = false;
            for(c in 0...lines[i].length) {
                var char = lines[i].charAt(c);
                switch(char) {
                    case '[':
                        isHidden = true;
                    case ']':
                        isHidden = false;
                    case ' ':
                        advance++;
                    default:
                        var e:Entity;
                        e = isHidden ? createQuestionBlock() : createLetterBlock(char);
                        e.get(Transform).position.set(x + advance *Config.blockSize, y);
                        result.push(e);
                        advance++;
                }
            }
            --i;
        }
        return result;
    }
}
