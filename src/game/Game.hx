package game;

import js.Lib;
import js.jquery.*;
import js.Browser.document;
import js.Browser.window;
import phaser.Game;
import phaser.Phaser;
import ash.core.Entity;
import ash.core.Engine;
import ash.core.Node;
import whiplash.*;
import whiplash.math.*;
import whiplash.phaser.*;
import whiplash.common.components.Active;

class Game {
    var engine:ash.core.Engine;
    var playerSprite:Sprite;
    var blockSprites:Array<Sprite>;
    var playerEntity:Entity;

    public function new() {
        new JQuery(window).on("load", function() {
            whiplash.Lib.init(320, 240, ".root", {preload:preload, create:create, update:update});
            engine = whiplash.Lib.ashEngine;
        });
    }

    function preload():Void {
        Factory.preload(whiplash.Lib.phaserGame);
    }

    function create():Void {
        var game = whiplash.Lib.phaserGame;
        game.stage.smoothed = false;
        Factory.init(game);
        whiplash.Input.setup(document.querySelector("canvas"));
        game.world.setBounds(0, 0, 760, 14*15);
        game.physics.startSystem(phaser.Physics.ARCADE);
        game.time.desiredFps = 60;
        game.physics.arcade.gravity.y = 250;

        var e = Factory.createSky();
        engine.addEntity(e);
        var e = Factory.createLevel();
        engine.addEntity(e);
        var e = Factory.createPlayer();
        engine.addEntity(e);
        playerEntity = e;
        playerSprite = e.get(Sprite);

        game.physics.enable(playerSprite, phaser.Physics.ARCADE);
        untyped playerSprite.body.collideWorldBounds = true;
        untyped playerSprite.body.setSize(14, 14);
        game.camera.follow(playerSprite);

        var es = Factory.createBlocks("Name: [gogoprog]\nThats it\noh yeah");
        blockSprites = [];
        for(e in es) {
            engine.addEntity(e);
            blockSprites.push(e.get(Sprite));
        }
    }

    function update():Void {
        var game = whiplash.Lib.phaserGame;
        var mouseCoords = whiplash.Input.mouseCoordinates;
        var dt = whiplash.Lib.getDeltaTime() / 1000;
        engine.update(dt);

        var mx = game.camera.x + mouseCoords.x * 0.5;

        if(playerSprite.position.x > mx) {
            untyped playerSprite.body.velocity.x = -100;
        } else {
            untyped playerSprite.body.velocity.x = 100;
        }

        if(game.input.mousePointer.isDown) {
            untyped playerSprite.body.velocity.y = -125;
        }
        game.physics.arcade.collide(playerSprite, blockSprites);
    }

    static function main():Void {
        new Game();
    }
}
