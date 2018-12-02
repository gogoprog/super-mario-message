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
        Factory.init(game);
        whiplash.Input.setup(document.querySelector(".root"));
        game.world.setBounds(0, 0, 760, 14*15);
        game.physics.startSystem(phaser.Physics.ARCADE);
        game.time.desiredFps = 30;
        game.physics.arcade.gravity.y = 250;

        var e = Factory.createSky();
        engine.addEntity(e);
        var e = Factory.createLevel();
        engine.addEntity(e);
        var e = Factory.createPlayer();
        engine.addEntity(e);
        var playerSprite = e.get(Sprite);

        game.physics.enable(playerSprite, phaser.Physics.ARCADE);
        untyped playerSprite.body.bounce.y = 0.2;
        untyped playerSprite.body.collideWorldBounds = true;
        untyped playerSprite.body.setSize(16, 16);
        untyped playerSprite.body.velocity.x = 100;
        game.camera.follow(playerSprite);
    }

    function update():Void {
        var dt = whiplash.Lib.getDeltaTime() / 1000;
        engine.update(dt);
        // whiplash.Lib.phaserGame.camera.x += dt * 100;
    }

    static function main():Void {
        new Game();
    }
}
