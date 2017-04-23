// AIR-DRAWER version 1.2.0 beta build 10
// Population version 1.2.0 beta build 6
// DNA version 1.2.0 beta build 11

//data of times and fitness
Table table = new Table();

Boolean ifContinue = true;
int endCount = 0;

PFont f;
PImage target;

PGraphics canvas; // GA drawing
PGraphics c_canvas1, c_canvas2; //Ga drawing cache

int popmax;
int dnaSize;
Population population;
int fitness, lastFitness;
int[] fitrgb, lastFitrgb = new int[3];
int gen;
int success;

String preset = "UltraFast";

String projectName = year() + "00".substring(str(month()).length()) + str(month()) + "00".substring(str(day()).length()) + str(day()) + "00".substring(str(hour()).length()) + str(hour()) + "00".substring(str(minute()).length()) + str(minute()) + "_AIR";

void setup() {
  size(512, 288);

  noStroke();
  smooth();

  f = createFont("Courier", 20, true);
  target = loadImage("Illya256crop.jpg");

  surface.setSize(target.width *2, target.height + 32);
  surface.setTitle("AIR-DRAWER v1.2.0 beta");

  table.addColumn("Gen");
  table.addColumn("Time");
  table.addColumn("Fitness");
  table.addColumn("Success");

  canvas = createGraphics(target.width, target.height);
  canvas.beginDraw();
  canvas.smooth();
  canvas.noStroke();
  canvas.background(255);
  canvas.endDraw();

  c_canvas1 = createGraphics(target.width, target.height);
  c_canvas1.beginDraw();
  c_canvas1.smooth();
  c_canvas1.noStroke();
  c_canvas1.background(255);
  c_canvas1.endDraw();

  popmax = 2000;
  dnaSize = 8;

  target.loadPixels();

  // Create a populationation with a target , mutation rate, and populationation max
  population = new Population(popmax, dnaSize);
  fitrgb = population.calFitness();
  lastFitness = fitrgb[0] + fitrgb[1] + fitrgb[2];
  lastFitrgb = fitrgb;
  
  fitness = lastFitness;
}

void draw() {

  success = 0;

  if (frameCount == 1) image(target, 0, 0);

  if (ifContinue) {

    for (int i = 0; i < population.population.length; i++) {

      population.population[i].mutate(preset);
      population.display(i);

      fitrgb = population.calFitness();
      fitness = fitrgb[0] + fitrgb[1] + fitrgb[2];

      //if before draw is better, rollback
      if (fitness < lastFitness) {
        population.copyFromOrigToBack();
        lastFitness = fitness;
        lastFitrgb = fitrgb;
        
        success++;
      } else {
        population.copyFromBackToOrig();
        fitness = lastFitness;
        fitrgb = lastFitrgb;
      }

      c_canvas1.beginDraw();
      population.population[i].draw(c_canvas1);
      c_canvas1.endDraw();
    }

    gen++;

    image(canvas, target.width, 0);
    TableRow newRow = table.addRow();
    newRow.setInt("Gen", gen);
    newRow.setInt("Time", millis());
    newRow.setInt("Fitness", fitness);
    newRow.setInt("Success", success);
  } else {
    exit();
    noLoop();
  }

  displayInfo();
  saveFrame("projects/" + projectName + "/frames/#####.jpg");
}

color selectBackgroundColor(PImage image) {
  int rsum = 0, gsum = 0, bsum = 0;
  int totalpixel = image.width * image.height;
  color averageColor;

  for (int x = 0; x < image.width; x++) {
    for (int y = 0; y < image.height; y++) {
      int loc = x + y*target.width;
      //int comploc = x + (y+(target.height))*target.width;
      color sourcepix = image.pixels[loc];

      //find the error in color (0 to 255, 0 is no error)
      rsum += red(sourcepix);
      gsum += green(sourcepix);
      bsum += blue(sourcepix);
    }
  }

  rsum = rsum / totalpixel;
  gsum = gsum / totalpixel;
  bsum = bsum / totalpixel;

  averageColor = color(rsum, gsum, bsum);
  println(rsum + " : " + gsum + " : " + bsum);

  return averageColor;
}

void displayInfo() {
  //display on console
  println("success " + success);
  println(fitrgb[0] + " : " + fitrgb[1] + " : " + fitrgb[2]);
  
  //display generation count
  textSize(20);
  textAlign(LEFT, CENTER);

  fill(0);
  rect(0, target.height, target.width * 2, 32);
  fill(0, 255, 255);
  text("Gen : " + gen, 10, target.height + 14);
  String hour = "00";
  String minute = "00";
  String second = "00";

  hour = "00".substring(str(millis()/3600000).length()) + str(millis()/3600000);
  minute = "00".substring(str((millis()/60000)%60).length()) + str((millis()/60000)%60);
  second = "00".substring(str((millis()/1000)%60).length()) + str((millis()/1000)%60);

  text("Time : " + hour + ":" + minute + ":" + second, 130, target.height + 14);
  text("Fitness : " + fitness / 3, 330, target.height + 14);
}

void keyPressed() {
  if ( key == 'q' || key == 'Q' || key == 'ㅂ') {
    println("starting ending sequence");
    ifContinue = false;
  } else if ( key == '1') {
    preset = "UltraFast";
    println("UltraFast");
  } else if ( key == '2') {
    preset = "SuperFast";
    println("SuperFast");
  } else if ( key == '3') {
    preset = "VeryFast";
    println("VeryFast");
  } else if ( key == '4') {
    preset = "Faster";
    println("Faster");
  } else if ( key == '5') {
    preset = "Fast";
    println("Fast");
  } else if ( key == '6') {
    preset = "Medium";
    println("Medium");
  } else if ( key == '7') {
    preset = "Slow";
    println("Slow");
  } else if ( key == '8') {
    preset = "Slower";
    println("Slower");
  } else if (key == '9' ) {
    preset = "VerySlow";
    println("VerySlow");
  } else if (key == '0' ) {
    preset = "Placebo";
    println("Placebo");
  } else if ( key == '!') {
    preset = "UltraFast(noRGB)";
    println("UltraFast(noRGB)");
  } else if ( key == '@') {
    preset = "SuperFast(noRGB)";
    println("SuperFast(noRGB)");
  } else if ( key == '#') {
    preset = "VeryFast(noRGB)";
    println("VeryFast(noRGB)");
  } else if ( key == '$') {
    preset = "Faster(noRGB)";
    println("Faster(noRGB)");
  } else if ( key == '%') {
    preset = "Fast(noRGB)";
    println("Fast(noRGB)");
  } else if ( key == '^') {
    preset = "Medium(noRGB)";
    println("Medium(noRGB)");
  } else if ( key == '&') {
    preset = "Slow(noRGB)";
    println("Slow(noRGB)");
  } else if ( key == '*') {
    preset = "Slower(noRGB)";
    println("Slower(noRGB)");
  } else if (key == '(' ) {
    preset = "VerySlow(noRGB)";
    println("VerySlow(noRGB)");
  } else if (key == ')' ) {
    preset = "Placebo(noRGB)";
    println("Placebo(noRGB)");
  } else if (key == 'c' ) {
    preset = "Color";
    println("Color");
  }
}

void exit() {

  saveTable(table, "projects/" + projectName + "/data.csv");
  println("saving canvas..");
  canvas.save("projects/" + projectName + "/result.png");
  println("saving dna");
  population.savefile();

  PGraphics scanvas; //Ga drawing render

  scanvas = createGraphics(target.width * 16, target.height * 16);
  scanvas.smooth();
  scanvas.beginDraw();
  scanvas.noStroke();
  scanvas.background(population.backgroundColor);
  scanvas.endDraw();

  for (int i = 0; i < population.population.length; i++) {
    scanvas.beginDraw();
    population.population[i].draw(scanvas);
    scanvas.endDraw();
    String count = "00000".substring(str(i).length()) + str(i);
    println(i + "/" + population.population.length);
    scanvas.save("projects/" + projectName + "/draw/" + count + ".jpg");
  }
  
  scanvas.save("projects/" + projectName + "/result(16x).png");
}