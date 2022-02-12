// STATES für unterschiedliche Screen im Spiel
final static byte STATE_STARTSCREEN = 0;
final static byte STATE_ZWISCHENSCREEN = 1;
final static byte STATE_FRAGESCREEN = 2;
final static byte STATE_RATESCREEN = 3;
final static byte STATE_LOESESCREEN = 4;
final static byte STATE_GAMEOVER = 5;
final static byte STATE_ZWISCHENLADEN = 6;
final static byte STATE_NEUESSPIEL = 7;

//design parameter
int randStaerke = 5;

// animations-parameter
int aniX_STARTSCREEN = 1;
float aniXtext_LOESESCREEN = 900;
float aniXzahl_LOESESCREEN = -100;

int aniY_ZWISCHENSCREEN = -20;
int aniY_FRAGESCREEN = -20;
int aniY_LOESESCREEN = -40;
int aniYY_LOESESCREEN = 1060;

// text input field variablen - kommen keyPressed() vor
int keyZaehler = 0;
ArrayList<String> charList = new ArrayList<String>();
String spielername ="";

// punkte, spielername, pos
int state;  
int spielerpunkte = 0;
float posX = -10; // Zielposition des markers (mouse user input)
float posY = -10; // startwerte außerhalb der karte

IntList reihenfolge; // random Zahlenfolge von 0 bis rappers.size
int rundenZaehler = 0;// index für die obige reihenfolge INtList
int rundenAnzeige = rundenZaehler +1; // Rundenanzeige immer rundenZaehler +1 (weil soll von 1. Runde losgehen)
int rundenpunkte; // in der jeweiligen Runde erzielte Punkte
int rundenZuSpielen = 5; // zu spielende Runden
int rappersSize;

// PImage Bilder
PImage karte;
PImage startBG;
PImage bgBLAU;

// wichtig
ArrayList<Stadt>  staedte;  
ArrayList<Rapper> rappers;

//___________________________________SETUP
void setup() {
  size(760, 900);
  smooth();

  // Städte- und Rapper-Arrays erstellen
  staedte = new ArrayList<Stadt>();
  rappers = new ArrayList<Rapper>();

  // rapperliste.txt & stadtliste.txt auslesen und in ArrayLists staedte & rapper schreiben
  leseStadt();
  leseRapper(); 

  // Rapper und Städte in Konsole ausgeben (zur Kontrolle gleich zu Beginn)
  printStadt();
  printRapper();

  // IntList für reihenfolge erstellen und shufflen
  reihenfolge = new IntList();
  for (int i = 0; i < rappers.size(); i++) {
    reihenfolge.append(i);
  }
  reihenfolge.shuffle();

  // gibt die gesamte IntList "reihenfolge' aus (zufallszahle von 0 bis rappers.size)
  println(reihenfolge);

  // Bilder laden
  karte   = loadImage("karte1.png");
  startBG = loadImage("startBG.jpg");
  bgBLAU =  loadImage("bgBLAU.jpeg");


  // state = 0, weil wir beim StartScreen anfangen
  state = 0;
}

//____________________________________DRAW
void draw() {
  switch(state) {
  case 0 :
    showStartScreen();
    break;
  case 1 :
    showZwischenScreen();
    break;
  case 2 :
    showFrageScreen(reihenfolge.get(rundenZaehler));
    break;
  case 3 :
    showRateScreen();
    break;
  case 4 :
    showLoeseScreen();
    break;
  case 5 :
    showGameOver();
    break;
  case 6 :
    zwischenladen();
    break;
  case 7 :
    neuesSpiel();
  }
}
//________________________________________________mousePressed()
void mousePressed() {
  switch(state) {
  case 3 :
    // ratescreen
    // untere rechte Ecke darf nicht drawMarker() auslösen - Bedingung:
    if (mouseX<width-95 || mouseY<height-90) {
      posX = mouseX;
      posY = mouseY;
    }
    break;
  }
}
//________________________________________________keyPressed()

void keyPressed() {
  switch(state) {
  case STATE_STARTSCREEN : 
    //_____________________________________________________________________________________
    // DAS HIER passiert bei jeder Taste außer...
    if (keyZaehler<12 && keyZaehler >= 0 &&
      keyCode != BACKSPACE && keyCode != ENTER && keyCode != SHIFT && keyCode != CONTROL &&
      keyCode != RETURN && keyCode != TAB && keyCode != DELETE && 
      keyCode != LEFT && keyCode != RIGHT && keyCode != UP && keyCode != DOWN) {

      // für die charList ArrayList
      charList.add(str(key));

      // zaehler muss sowieso steigen
      keyZaehler++;
    }
    //______________________________________________________________________________________
    // DAS HIER passiert nur bei den "Sondertasten"
    if (key != CODED) {
      switch(key) {
      case BACKSPACE:
        if (keyZaehler>0) {
          charList.remove(keyZaehler-1);
          keyZaehler--;
        }
        break;
      case RETURN:
      case ENTER:
        // spielernamen aus charlist auslesen
        if (charList.size()>0) {
          for (int i = 0; i < charList.size(); i++) {
            spielername += charList.get(i); // in jedem step erweitert sich spielername um einen char
          }
          println(spielername);
          charList.clear();  // charList leer machen
          state=STATE_ZWISCHENSCREEN;
          break;
        } else {
          // Namen eingeben blinkt rot
          gameText("Namen eingeben", width/2, 715, 30, 255, 0, 0, 200);
        }
      }
    }
  }
}

//_________________________________________________________SCREENS_______________________________________________________________
//................................................................................................0
void showStartScreen() {

  // bewegtes Hintergrundbild
  imageMode(CORNER);
  image(startBG, aniX_STARTSCREEN, 0);
  aniX_STARTSCREEN-=1; // Geschwindigkeit, mit der sich startBG.png bewegt
  if (aniX_STARTSCREEN<-2323) {
    aniX_STARTSCREEN=1;
  }
  // textInput Feld
  textInput(220, 680, 50);
  // startButton
  startButton(width/2, 780, 150, 50);
} 
//................................................................................................1
void showZwischenScreen() {
  background(110, 100, 100);

  gameText("RUNDE " + rundenAnzeige, width/2, aniY_ZWISCHENSCREEN, 75, 255, 0, 0, 150);
  aniY_ZWISCHENSCREEN+=15;
  
  if (aniY_ZWISCHENSCREEN==445){
    delay(1200);
  }
  if(aniY_ZWISCHENSCREEN >= height+100){
    state=STATE_FRAGESCREEN;
  }
}
//................................................................................................2
void showFrageScreen(int zuf) {
  background(110, 100, 100);

  // Bild des Rappers fährt von oben mit der step-Größe aniYY runter
  fill(0, 0, 0, 90);
  noStroke();
  rectMode(CENTER);
  rect(width/2, aniY_FRAGESCREEN, 550, 550, 15);
  rappers.get(zuf).showRapperBild(width/2, aniY_FRAGESCREEN, 500, 255);

  gameTextBlock("Woher kommt ______ ?", width/2, height*0.8, 30, 0, 0, 0, 200);
  if (aniY_FRAGESCREEN<width/2) {
    aniY_FRAGESCREEN+=10;
  } else {
    button("WEITER", width/2, 780, 110, 40, STATE_RATESCREEN, 0);
  }
}
//................................................................................................3
void showRateScreen() {
  // zu erratenden Rapper als seichtes Hintergrundbild anzeigen (muss ZUERST angezeigt werden)
  rappers.get(reihenfolge.get(rundenZaehler)).showRapperBild(width/2, height/2, height, 150);

  // zeige Karte (muss NACH rapperBild angezeigt werden)
  showKarte();

  // Score einblenden
  textSize(20);
  fill(0, 0, 0, 150);
  text(spielername, 50, 30);
  text(spielerpunkte, 50, 50);

  // marker zeichnen, wo wir hinklicken (posX & posY werden in mousePresed() festgelegt)
  drawMarker(posX, posY, 139, 10, 80);

  // button unten rechts als Bestätigung
  if (posX!=-10 && state == STATE_RATESCREEN) {
    button("OK", width-60, height-60, 50, 30, STATE_LOESESCREEN, 0);
  }
}
//................................................................................................4
void showLoeseScreen() {

  int pos=1;

  // NOCHMAL rapperBild, karte und User-Marker Malen
  rappers.get(reihenfolge.get(rundenZaehler)).showRapperBild(width/2, height/2, height, 150);
  showKarte();

  // Zonen um den Zielort
  if (geoToY(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lat)<height/2) {
    pos*=-1;
  }
  // Text in Kreisen
  noStroke();
  gameText("500", 
    geoToX(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lon), 
    geoToY(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lat)-(pos*100), 
    20, 255, 255, 255, 150);
  gameText("250", 
    geoToX(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lon), 
    geoToY(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lat)-(pos*200), 
    18, 255, 255, 255, 150);
  gameText("100", 
    geoToX(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lon), 
    geoToY(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lat)-(pos*300), 
    16, 255, 255, 255, 150);
  // Kreise zeichenen
  fill(150, 100, 100, 60);
  ellipse(geoToX(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lon), 
    geoToY(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lat), 200, 200);
  ellipse(geoToX(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lon), 
    geoToY(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lat), 400, 400);
  ellipse(geoToX(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lon), 
    geoToY(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lat), 600, 600);

  // aktueller score
  textSize(20);
  fill(0, 0, 0, 150);
  text(spielername, 50, 30);
  text(spielerpunkte, 50, 50);

  // Linie zwischen geratenem und richtigem Punkt zeichnen
  strokeWeight(1.5);
  stroke(255, 0, 0);
  line(posX, posY, 
    geoToX(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lon), 
    geoToY(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lat));

  // nochmal Marker malen
  drawMarker(posX, posY, 139, 10, 80);

  // Kreis auf richtigem Punkt zeichnen
  strokeWeight(3);
  stroke(50, 40, 40, 200);
  fill(255, 0, 0, 230);
  ellipse(geoToX(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lon), 
    geoToY(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lat), 
    10, 10);

  // Rundenpunkte errechnen (punkteVergabe()) und als gameText ausgeben
  rundenpunkte = punkteVergabe(posX, 
    geoToX(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lon), 
    posY, 
    geoToY(rappers.get(reihenfolge.get(rundenZaehler)).stadt.lat));

  // Punkte und Text "fliegen" durchs Bild
  gameText("Punkte", aniXtext_LOESESCREEN, height/2+80, 90, 0, 0, 0, 150);
  aniXtext_LOESESCREEN-=3; 
  if (aniXtext_LOESESCREEN<-180) {
    aniXtext_LOESESCREEN=900;
  }
  gameText(" " + rundenpunkte + " ", aniXzahl_LOESESCREEN, height/2, 120, 240, 0, 0, 150);
  aniXzahl_LOESESCREEN+=3;
  if (aniXzahl_LOESESCREEN>900) {
    aniXzahl_LOESESCREEN=-70;
  }

  // Namen des Rappers oben reinfahren lassen
  gameTextBlock(rappers.get(reihenfolge.get(rundenZaehler)).name, width/2, aniY_LOESESCREEN, 50, 0, 0, 0, 200);
  if (aniY_LOESESCREEN < 65) {
    aniY_LOESESCREEN+=4;
  } else {
    if (rundenAnzeige==rundenZuSpielen) {
      // button zu den Highscores
      button("zu den Scores", width/2, 760, 180, 40, STATE_ZWISCHENLADEN, 1);
    } else {
      // button zur nächsten Runde
      button("nächste Runde", width/2, 760, 180, 40, STATE_ZWISCHENLADEN, 1);
    }
  }

  // Namen der Stadt des Rappers von unten reinfahren lassen
  gameTextBlock(rappers.get(reihenfolge.get(rundenZaehler)).stadt.name, width/2, aniYY_LOESESCREEN, 50, 0, 0, 0, 200);
  if (aniYY_LOESESCREEN > 865) {
    aniYY_LOESESCREEN-=4;
  }
} // ende showLoeseScreen

//................................................................................................5
void showGameOver() {
  image(bgBLAU, 0, 0);
  drawHighscores();

  // button für neue Runde
  button("noch ne Runde", width/2, 830, 200, 40, STATE_NEUESSPIEL, 1);
}
//................................................................................................6
void zwischenladen() {
  background(0);
  // animationsparameter auf "außerhalb des screens" zurücksetzen
  aniY_ZWISCHENSCREEN = -20;
  aniY_FRAGESCREEN = -20;
  aniY_LOESESCREEN = -20;
  aniYY_LOESESCREEN = 1000;
  aniXzahl_LOESESCREEN = -100;
  aniXtext_LOESESCREEN = 900;

  rundenZaehler++;
  rundenAnzeige++;
  spielerpunkte+=rundenpunkte;

  posX = -10;
  posY = -10;
  if (rundenAnzeige-1==rundenZuSpielen) {
    state = STATE_GAMEOVER;
  } else {
    state = STATE_ZWISCHENSCREEN;
  }
}

//................................................................................................7
void neuesSpiel() {
  background(0);
  // animationsparameter auf "außerhalb des screens" zurücksetzen
  aniY_ZWISCHENSCREEN = -20;
  aniY_FRAGESCREEN = -20;
  aniY_LOESESCREEN = -20;
  aniYY_LOESESCREEN = 1000;
  aniXzahl_LOESESCREEN = -100;
  aniXtext_LOESESCREEN = 900;

  rundenAnzeige=1;
  spielerpunkte=0;
  spielername="";
  keyZaehler = 0;

  state=STATE_STARTSCREEN;
}

//_________________________________________________________ELEMENTE_______________________________________________________________

//____ karte anzeigen________________________________________________________
void showKarte() {
  imageMode(CORNER);
  image(karte, 0, 0);
}
//___________________________________________________________________________
// text input field anzeigen und charList befüllen (spielername wird noch nicht berührt)
void textInput (int xpos, int ypos, int size) {
  float w = 12*size*0.53;
  // REC
  stroke(0, 0, 0, 200);
  fill(255, 255, 255, 100);
  strokeWeight(5);
  rectMode(CORNER);
  rect(xpos, ypos, w, size, 7);

  // "Namen eingeben"
  gameText("Namen eingeben", width/2, 715, 30, 255, 255, 255, 60);

  // TEXT
  for (int i = 0; i < charList.size(); i++) {
    textAlign(CENTER);
    fill(0, 0, 0, 240);
    textSize(size*0.7);
    text(charList.get(i), xpos+(size/2.3) +i*size*0.5, ypos+size*0.75);
  }
}

//____ gameText _____________________________________________________________
void gameText(String string, float x, float y, float size, int r, int g, int b, int alpha) {

  textAlign(CENTER);
  textSize(size);
  fill(r, g, b, alpha);
  text(string, x, y);
}

//____ gameTextBlock ________________________________________________________
void gameTextBlock(String string, float x, float y, float size, int r, int g, int b, int alpha) {
  stroke(0, 0, 0, 200);
  strokeWeight(randStaerke+1);
  fill(255, 255, 255, 200);
  rectMode(CENTER);
  rect(x, y-(size/2.8), string.length()*0.65*size, size*1.3, 7); 
  gameText(string, x, y, size, r, g, b, alpha);
}

//____ button _______________________________________________________________
void button (String string, float x, float y, int w, int h, int toState, int tr) {
  // Rechteck
  rectMode(CENTER);
  stroke(0, 0, 0, 150);
  strokeWeight(5);
  fill(255, 255, 255, 200);
  rect(x, y, w, h, 7);
  // Text
  gameText(string, x, y+(h/4), h*0.6, 0, 0, 0, 255);

  // MouseOver-Bedingung
  if (mouseX > x-(w/2) && mouseX < x+(w/2) &&
    mouseY > y-(h/2) && mouseY < y+(h/2)) {

    // Hintergrund in anderer Farbe
    fill(255, 0, 0, 100);
    rect(x, y, w, h, 7);
    gameText("" + string, x, y+(h/4), h*0.6, 0, 0, 0, 255);

    // Klick-Bedingung
    if (mousePressed) {
      // wenn tr=1, dann male erst den Hintergrund bevor du zum nächsten STATE wechselst
      if (tr==1) {
        background(255);
      }
      state = toState;
    }
  }
}
//______________________startButton _________________________________________
void startButton (float x, float y, int w, int h) {
  // Rechteck
  rectMode(CENTER);
  stroke(0, 0, 0, 200);
  strokeWeight(randStaerke);
  fill(255, 255, 255, 100);
  rect(x, y, w, h, 7);
  // Text
  gameText("START", x, y+(h/4), h*0.6, 0, 0, 0, 255);

  // MouseOver-Bedingung
  if (mouseX > x-(w/2) && mouseX < x+(w/2) &&
    mouseY > y-(h/2) && mouseY < y+(h/2)) {

    // Hintergrund in anderer Farbe
    fill(255, 0, 0, 100);
    rect(x, y, w, h, 7);
    gameText("START", x, y+(h/4), h*0.6, 0, 0, 0, 255);

    // Klick-Bedingung
    if (mousePressed) {
      // spielernamen aus charlist auslesen
      if (charList.size()>0) {
        for (int i = 0; i < charList.size(); i++) {
          spielername += charList.get(i); // in jedem step erweitert sich spielername um einen char
        }
        println(spielername);
        charList.clear();  // charList leer machen

        // zum ZWISCHENSTATE nur wenn ein Name drinsteht
        state = STATE_ZWISCHENSCREEN;
      } else {
        // Namen eingeben blinkt rot
        gameText("Namen eingeben", width/2, 715, 30, 255, 0, 0, 200);
      }
    }
  }
}

//______________________marker(Pfeil)________________________________________________
void drawMarker(float x, float y, int r, int g, int b) {
  strokeWeight(3);
  stroke(r, g, b);
  line(x, y, x, y-12);   // senkrechte linie
  line(x, y, x-6, y-6); // schräge linie nach links
  line(x, y, x+6, y-6); // schräge linie nach rechts
}

// ____ checkBox _____________________________________________________________
void checkBox(float x, float y, int w, int h) {

  // Rechteck, "Checkbox-Outlines"
  rectMode(CENTER);
  fill(255);
  stroke(0);
  rect(x, y, w, h);

  // wenn Checkbox geklickt wird, ...
  if (mousePressed==true && 
    mouseX > x-(w/2) && mouseX < x+(w/2) &&
    mouseY > y-(h/2) && mouseY < y+(h/2)) {

    stroke(0);
    line(x-(w/2), y-(h/2), x+(w/2), y+(h/2));
    line(x+(w/2), y-(h/2), x-(w/2), y+(h/2));
  }
}

//_________________________________________________________STÄDTE_EINLESEN_________________________________________
void leseStadt() {

  // lese stadtliste.txt aus und schreibe jede Zeile als einzelnen String in den stadtArray[] (nur vorübergehend)
  String[] stadtArray = loadStrings("txt/stadtliste.txt");

  // erstelle neue Stadt-Objekte aus Listeneinträgen
  for (int i = 0; i<stadtArray.length; i+=3) {
    String sName = stadtArray[i];          // jede 0., 3., 6., 9., ... Zeile
    float sLat = float(stadtArray[i+1]);   // jede 1., 4., 7., 10., .. Zeile
    float sLon = float(stadtArray[i+2]);   // jede 2., 5., 8., 11., .. Zeile
    staedte.add(new Stadt(sName, sLat, sLon)); // stadt erstellen und zur ArrayList hinzufügen
  }
}

//_________________________________________________________RAPPER_EINLESEN_________________________________________
void leseRapper() {

  // lese rapperliste.txt aus und schreibe jede Zeile als einzelnen String in den rapperArray[] (nur vorübergehend)
  String[] nurRapper = loadStrings("txt/rapperName.txt");
  String[] nurStadt = loadStrings("txt/rapperStadt.txt");

  // erstelle neue Rapper-Objekte aus Listeneinträgen
  for (int i = 0; i < nurRapper.length; i++) {
    String rName = nurRapper[i];        // jede 0., 2., 4., 6., ... Zeile
    String rStadt = nurStadt[i];     // jede 1., 3., 5., 7., ... Zeile

    // jedes mal prüfen, ob Stadtname in Rapperliste als Stadt-Objekt existiert
    // Rapper wird nur erstellt, wenn es die Stadt als Stadt-Objekt in staedte ArrayList gibt
    for (int n = 0; n < staedte.size(); n++) {
      if (rStadt.equals(staedte.get(n).name)) {
        rappers.add(new Rapper(rName, staedte.get(n)));
      }
    }
  }
}

//__________________________________________________STÄDTE_IN_KONSOLE_AUSGEBEN_____________________________________
void printStadt() {
  // gebe alle gespeicherten Stadtobjekte (mit ihren Instanzvariablen) auf der Konsole aus
  println("Anzahl gesp. Staedte: " + staedte.size() + "\n");
  for (int i = 0; i < staedte.size(); i++) {
    staedte.get(i).stadtInKonsole();
  }
  println("______________________");
}

//____________________________________________________RAPPER_IN_KONSOLE_AUSGEBEN____________________________________
void printRapper() {
  // gebe alle gespeicherten Rapper-Objekte auf der Konsole aus
  println("Anzahl gesp. Rapper: " + rappers.size() + "\n");
  for (int i = 0; i < rappers.size(); i++) {
    rappers.get(i).rapperInKonsole();
  }
  println("_______________________");
}

//______________________________________________ Game High Score in textdatei speichern____________________________
void drawHighscores() {
  // Liste auslesen und Werte / Namen in Variablen schreiben
  String[] scores = loadStrings("txt/highscores.txt");
  int startPosY = 10;
  int highscore1 = Integer.parseInt(scores[1]);
  int highscore2 = Integer.parseInt(scores[3]);
  int highscore3 = Integer.parseInt(scores[5]);

  // Bedingungen für Platz 1, 2 und 3 in der Highscore-liste
  if (spielerpunkte>highscore1) {
    highscore3 = highscore2;
    highscore2 = highscore1;
    highscore1 = spielerpunkte;
    scores[0] = spielername;
  } else if (spielerpunkte > highscore2 && spielerpunkte < highscore1) {
    highscore3 = highscore2;
    highscore2 = spielerpunkte;
    scores[2] = spielername;
  } else if (spielerpunkte > highscore3 && spielerpunkte < highscore2) {
    highscore3 = spielerpunkte;
    scores[4] = spielername;
  }
  scores[1] = String.valueOf(highscore1);
  scores[3] = String.valueOf(highscore2);
  scores[5] = String.valueOf(highscore3);

  saveStrings("data/txt/highscores.txt", scores);

  // zeige Highscores untereinander an
  gameText("HIGHSCORES", width/2, 100, 90, 0, 0, 0, 200);

  gameText("1", width/2, 256+startPosY, 150, 0, 0, 0, 40);  
  gameText(scores[0], width/2, 200+startPosY, 50, 0, 0, 0, 240);
  gameText(scores[1], width/2, 250+startPosY, 40, 255, 0, 0, 255);

  gameText("2", width/2, 360+startPosY, 105, 0, 0, 0, 40);   
  gameText(scores[2], width/2, 310+startPosY, 40, 0, 0, 0, 2220);
  gameText(scores[3], width/2, 350+startPosY, 35, 255, 0, 0, 255);

  gameText("3", width/2, 460+startPosY, 90, 0, 0, 0, 40);     
  gameText(scores[4], width/2, 420+startPosY, 30, 0, 0, 0, 200);
  gameText(scores[5], width/2, 450+startPosY, 25, 255, 0, 0, 255);

  // Zeige Endscore des Spieler, Spielerpunkte, Spielernamen an
  gameText("ENDSCORE", width/2, 600, 75, 0, 0, 0, 230);
  gameText(spielername, width/2, 655, 50, 255, 0, 0, 200);
  gameText(" " + spielerpunkte + " ", width/2, 730, 80, 255, 0, 0, 255);
}
//_____________________________________________________UMRECHNEN___________________________________________________
float geoToX(float geo) {
  float x = map(geo, 5.5, 15.5, 0, width);
  return x;
}
float geoToY(float geo) {
  float y = map(geo, 55.1, 47.2, 0, height);
  return y;
}
float xToGeo(float x) {
  float geo = map(x, 0, width, 5.5, 15.5);
  return geo;
}
float yToGeo(float y) {
  float geo = map(y, 0, width, 55.1, 47.2);
  return geo;
}
float distanzInKm (float lon_start, float lat_start, float lon_ziel, float lat_ziel) {
  float lat  = (lat_start+lat_ziel)/2*0.01745;
  float dx   = 111.3 * cos(lat) * (lon_start - lon_ziel);
  float dy   = 111.3 * (lat_start - lat_ziel);
  float dist = sqrt(dx*dx+dy*dy);
  return dist;
}
//__________________________________ PUNKTE BERECHNEN_______________________________________________________________
int punkteVergabe (float lon_ziel, float lon_start, float lat_ziel, float lat_start) {
  int pixelDistanz = (int)sqrt(sq(lon_ziel-lon_start)+sq(lat_ziel-lat_start));
  int punkte = 0;

  // Anfang der unterschiedlichen Punktebereiche
  if (pixelDistanz < 10) {
    punkte = 1000;
  }
  if (pixelDistanz >=  10 && pixelDistanz < 100) {
    // Bereich 1
    punkte = (int)map(pixelDistanz, 10, 100, 1000, 500);
  }
  if (pixelDistanz >= 100 && pixelDistanz < 200) {
    // Bereich 2
    punkte = (int)map(pixelDistanz, 100, 200, 500, 250);
  }
  if (pixelDistanz >= 200 && pixelDistanz < 300) {
    // Bereich 3
    punkte = (int)map(pixelDistanz, 200, 300, 250, 100);
  }  
  if (pixelDistanz >= 300 && pixelDistanz < 400) {
    // Bereich 4
    punkte = (int)map(pixelDistanz, 300, 400, 100, 50);
  }
  if (pixelDistanz >= 400 && pixelDistanz < 700) {
    // Bereich 5
    punkte = (int)map(pixelDistanz, 400, 700, 50, 5);
  }
  if (pixelDistanz >= 700 && pixelDistanz < 1200) {
    // Bereich 6
    punkte = (int)map(pixelDistanz, 700, 1200, 5, 0);
  }
  // ende der Bereiche
  return punkte;
}
//_________________________________________________ANZEIGE OBEN LINKS _________________________________________
// zeige BG und LG oben links auf dem screen
void showBgLg () {
  float xpos = map(mouseX, 0, width, 5.5, 15.5);
  float ypos = map(mouseY, 0, height, 55.1, 47.2);
  fill(0, 0, 0, 150);
  textSize(16);
  textAlign(LEFT);
  text("LG:  " + xpos + "°", 5, 20);
  text("BG:  " + ypos + "°", 5, 40);
}
// zeiuge Pixel-KO oben links
void showKO () {
  fill(0, 0, 0, 150);
  textSize(16);
  textAlign(LEFT);
  text("x:  " + mouseX, 5, 20);
  text("y:  " + mouseY, 5, 40);
}
