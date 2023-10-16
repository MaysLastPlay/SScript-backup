import tea.*;

class Main {
    static function main() {
        var s = new SScript();
        s.doString("
            trace(1 is Type);
        ", 'Cock');
        trace(s.parsingException);
    }
}