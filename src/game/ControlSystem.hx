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
    private var wasNotPressed:Bool = false;
    private var jumping:Bool = false;
    private var jumpTime:Float = 0;
    private var lastMx:Float = 100;

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
            untyped node.sprite.entity = node.entity;
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
            var mx = phaserGame.camera.x + mouseCoords.x * 320 / untyped $('canvas').width();
            var px = playerSprite.position.x;
            if(!whiplash.Input.mouseButtons[0]) {
                mx = lastMx;
            } else {
                lastMx = mx;
            }
            var dx = Math.abs(px - mx);
            var dir = px > mx ? -1 : 1;
            var playerBody = playerSprite.body;
            var playerVelocity = untyped playerBody.velocity;
            var vx = playerVelocity.x;
            var vy = playerVelocity.y;
            if(dx > Config.moveMinDistance) {
                var distance = Math.min(dx, Config.moveMaxDistance);
                var factor = distance / Config.moveMaxDistance;
                untyped playerVelocity.x = Config.moveSpeed * factor * dir;
                if(!jumping) {
                    if(vy  == 0) {
                        playerSprite.animations.play('walk', 15, true);
                    }
                    playerSprite.animations.currentAnim.speed = 16 * factor;
                }
            } else {
                untyped playerBody.velocity.x = 0;
                if(vy == 0) {
                    playerSprite.animations.play('idle', 15, true);
                }
            }
            playerEntity.get(Transform).scale.x = dir;
            if(canJump && vy == 0) {
                if(whiplash.Input.mouseButtons[0]) {
                    if(wasNotPressed) {
                        untyped playerBody.velocity.y = Config.jumpVelocity;
                        canJump = false;
                        jumping = true;
                        playerSprite.animations.play('jump', 15, true);
                        AudioManager.playSound("jump");
                        wasNotPressed = false;
                    }
                } else {
                    wasNotPressed = true;
                }
            }
            if(jumping) {
                if(jumpTime < Config.jumpMaxTime && whiplash.Input.mouseButtons[0]) {
                    untyped playerBody.velocity.y = Config.jumpVelocity;
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
            if(untyped a.body.touching.up && untyped b.body.touching.down) {
                var e:Entity = untyped b.entity;
                if(e.get(Shake) == null) {
                    e.add(new Shake());
                    AudioManager.playSound("bump");
                }
            }
        }
    }
    private function hitWorldBounds(player) {
        if(player.body.position.y >= 192) {
            resetJump();
        }
    }
    public function resetJump() {
        jumpTime = 0;
        canJump = true;
        jumping = false;
    }
}


