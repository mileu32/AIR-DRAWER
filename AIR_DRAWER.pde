// AIR-DRAWER version 1.2.0 beta build 5
// Population version 1.2.0 beta build 5
// DNA version 1.1.0 build 5

//data of times and fitness
Table table = new Table();

Boolean ifContinue = true;
int endCount = 0;

PFont f;
PImage target;

PGraphics canvas; // GA drawing
PGraphics c_canvas1, c_canvas2; //Ga drawing cache
PGraphics scanvas; //Ga drawing render
int rootpopmax;
int popmax;
int dnaSize;
Population population;
int fitness, lastFitness, originFitness;
int[] fitrgb =new int[3];
int gen;

boolean turboMode = false;
String preset = "UltraFast";

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

  scanvas = createGraphics(target.width * 16, target.height * 16);

  scanvas.smooth();
  scanvas.beginDraw();

  scanvas.noStroke();
  scanvas.background(255);
  scanvas.endDraw();

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

  c_canvas2 = createGraphics(target.width, target.height);
  c_canvas2.beginDraw();
  c_canvas2.smooth();
  c_canvas2.noStroke();
  c_canvas2.endDraw();

  rootpopmax = 48;
  popmax = rootpopmax * rootpopmax;

  dnaSize = 8;

  target.loadPixels();

  // Create a populationation with a target , mutation rate, and populationation max
  population = new Population(popmax, dnaSize);
  fitrgb = population.calFitness();
  lastFitness = fitrgb[0] + fitrgb[1] + fitrgb[2];

  fitness = lastFitness;
  originFitness = fitness;
}

void draw() {

  int success = 0;

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
        success++;
      } else {
        population.copyFromBackToOrig();
        fitness = lastFitness;
      }

      c_canvas1.beginDraw();
      population.population[i].draw(c_canvas1);
      c_canvas1.endDraw();
    }

    gen++;
    println("success " + success);
    println(fitrgb[0] + " : " + fitrgb[1] + " : " + fitrgb[2]);
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
  saveFrame("frames/#####.jpg");
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
  } else if (key == 'c' ) {
    preset = "Color";
    println("Color");
  }
}

void exit() {
  saveTable(table, "data/data.csv");
  println("saving canvas..");
  canvas.save("data/result.png");
  println("saving dna");

  scanvas.beginDraw();
  scanvas.background(population.backgroundColor);
  scanvas.endDraw();

  for (int i = 0; i < population.population.length; i++) {
    scanvas.beginDraw();
    population.population[i].draw(scanvas, 16);
    scanvas.endDraw();
    String count = "00000".substring(str(i).length()) + str(i);
    println(i + "/" + population.population.length);
    scanvas.save("draw/"+count+".jpg");
  }
  scanvas.save("data/result(16x).png");
}