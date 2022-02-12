class Stadt {

  String name; // Stadtname
  float lon;   // Längengrad der Stadt als Dezimal-Grad (X-Wert: 5,5 - 15)
  float lat;   // Breitengrad der Stadt als Dezimal-Grad (Y-Werte: 55 - 47,2)


  // Konstruktor
  Stadt(String name, float lat, float lon) {
    this.name = name;
    this.lat = lat; // Breitengrad (Y)
    this.lon = lon; // Längengrad (X)
  }

  // Gibt Stadtnamen und Stadt-KO (BG & LG) in der Konsole aus
  void stadtInKonsole() {
    println(this.name + ":        \t" + this.lat + "°\t" + this.lon +"°");
  }

  // zeichnet Stadt als roten Punkt auf der Karte
  void display() {

    // HIER findet Umrechnung lat >> latXY und lon >> lonXY statt
    float lonXY = map(lon, 5.5, 15.5, 0, width);
    float latXY = map(lat, 55.1, 47.2, 0, height);


    // zeichne roten, halb-transparenten Punkt
    fill(255, 0, 0, 120);
    noStroke();
    ellipse(lonXY, latXY, 15, 15);

    // schreibe Namen der Stadt neben Punkt
    fill(0);
    textSize(15);
    textAlign(CENTER);
    text(this.name, lonXY, latXY-12);
  }
}//ende Stadt class