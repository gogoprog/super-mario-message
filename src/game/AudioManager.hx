package game ;

class AudioManager {
    static public var sounds:Map<String, Dynamic> = [
                "overworld" => null,
                "jump" => null,
                "coin" => null,
                "1up" => null,
                "bump" => null,
            ];
    static public var music:Dynamic;

    static public function preload(game:phaser.Game) {
        for(name in sounds.keys()) {
            game.load.audio(name, "../data/audio/" + name + ".ogg");
        }
    }

    static public function init(game:phaser.Game) {
        for(name in sounds.keys()) {
            sounds[name] = game.add.audio(name);
        }
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
        sounds[name].play('', 0, 0.5, true);
        music = sounds[name];
    }
}
