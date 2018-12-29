package game ;

class AudioManager {
    static public var sounds:Map<String, Dynamic> = new Map();
    static public var music:Dynamic;

    static public function preload(game:phaser.Game) {
        game.load.audio("music", "../data/audio/overworld.ogg");
    }

    static public function init(game:phaser.Game) {
        sounds["music"] = game.add.audio("music");
    }

    static public function playSound(name) {
        if(!sounds.exists(name)) {
            trace("Unknown sound: " + name);
            return;
        }
        sounds[name].play();
    }

    static public function playMusic(name) {
        if(sounds[name] == music) {
            return;
        }
        if(music != null) {
            music.stop();
        }
        sounds[name].play('', 0, 1, true);
        music = sounds[name];
    }
}
