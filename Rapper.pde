class Rapper {

  // Jeder Rapper hat einen Namen, eine Heimatstadt und ein Bild
  String name;
  Stadt stadt;
  PImage bild; //noch nicht beachtet


  // Konstruktor für Rapper
  Rapper(String name, Stadt stadt) {
    this.name = name;
    this.stadt = stadt;
    bild = loadImage("bilder/" + name + ".jpg");
  }

  // Gibt Rapper + Hometown in Konsole aus
  void rapperInKonsole() {
    println(this.name + ": " + this.stadt.name);
  }

  // Bild anzeigen
  void showRapperBild(float x, float y, int newHeight, int t1) {
    imageMode(CENTER);
    bild.resize(0, newHeight);
    tint(255, t1);
    image(bild, x, y);
  }
}//ende Rapper class