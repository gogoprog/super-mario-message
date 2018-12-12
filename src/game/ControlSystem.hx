package game;

import ash.core.*;
import whiplash.phaser.*;

class BlockNode extends Node<BlockNode> {
    public var sprite:Sprite;
    public var block:Block;
}

class ControlSystem extends ash.core.System {
    private var playerEntity:Entity;
    private var playerSprite:Sprite;
    private var phaserGame:phaser.Game;
    private var blockSprites:Array<Sprite> = [];
    private var mouseEnabled:Bool = true;
    private var canJump:Bool = false;
    private var jumping:Bool = false;
    private var jumpTime:Float = 0;

    public function new() {
        super();
    }

    public override function addToEngine(engine:Engine) {
        super.addToEngine(engine);
        playerEntity = engine.getEntityByName("player");
        playerSprite = playerEntity.get(Sprite);
        phaserGame = whiplash.Lib.phaserGame;
        var list = engine.getNodeList(BlockNode);
        for(node in list) {
            blockSprites.push(node.sprite);
        }
        untyped playerSprite.body.onWorldBounds = untyped __js__("new Phaser.Signal()");
        untyped playerSprite.body.onWorldBounds.add(hitWorldBounds, this);
    }

    public override function removeFromEngine(engine:Engine) {
        super.removeFromEngine(engine);
    }

    public override function update(dt:Float) {
        phaserGame.physics.arcade.collide(playerSprite, blockSprites, onCollide);
        if(mouseEnabled) {
            var mouseCoords = whiplash.Input.mouseCoordinates;
            var mx = phaserGame.camera.x + mouseCoords.x * 0.5;
            var px = playerSprite.position.x;
            var dx = Math.abs(px - mx);
            var dir = px > mx ? -1 : 1;
            if(dx > 16) {
                untyped playerSprite.body.velocity.x = Math.min(dx, 100) * dir;
            } else {
                untyped playerSprite.body.velocity.x = 0;
            }
            playerEntity.get(Transform).scale.x = dir;
            if(canJump) {
                if(whiplash.Input.mouseButtons[0]) {
                    untyped playerSprite.body.velocity.y = -200;
                    canJump = false;
                    jumping = true;
                }
            }
            if(jumping) {
                if(jumpTime < 0.3 && whiplash.Input.mouseButtons[0]) {
                    untyped playerSprite.body.velocity.y = -200;
                } else {
                    jumping = false;
                }
                jumpTime += dt;
            }
        }
        if(whiplash.Input.keys[" "]) {
            untyped playerSprite.body.velocity.y = -200;
        }
    }

    public function render() {
        if(whiplash.Input.keys["F2"]) {
            phaserGame.debug.body(playerSprite);
            for(b in blockSprites) {
                phaserGame.debug.body(b);
            }
        }
    }

    private function onCollide(a, b) {
        if(a == playerSprite) {
            if(untyped a.body.touching.down && untyped b.body.touching.up) {
                resetJump();
            }
        }
    }

    private function hitWorldBounds(player) {
        if(player.body.position.y >= 195) {
            resetJump();
        }
    }

    private function resetJump() {
        jumpTime = 0;
        canJump = true;
        jumping = false;
    }
}


