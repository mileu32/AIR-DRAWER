// AIR-DRAWER version 1.0.0 build 1

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
Canvas population;
int fitness, lastFitness, originFitness;
int gen;

void setup() {
  size(256, 576);

  noStroke();
  smooth();

  f = createFont("Courier", 32, true);
  target = loadImage("lenna256.png");

  surface.setSize(target.width, target.height * 2 + 70);

  table.addColumn("Gen");
  table.addColumn("Time");
  table.addColumn("Fitness");

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

  //rootpopmax = (target.width + target.height) / 10;
  rootpopmax = 64;
  popmax = rootpopmax * rootpopmax;

  dnaSize = 8;

  image(target, 0, 0);
  target.loadPixels();

  // Create a populationation with a target , mutation rate, and populationation max
  population = new Canvas(popmax, dnaSize);

  lastFitness = population.calFitness();

  fitness = lastFitness;
  originFitness = fitness;
}

void draw() {
  saveFrame("frames/#####.jpg");

  if (ifContinue) {
    if (fitness < 230000) exit();

    for (int i = 0; i < population.population.length; i++) {
      String preset = "medium";

      if (fitness > 2500000) preset = "slow";
      else if (fitness > 2000000) preset = "slow";
      else if (fitness > 1700000) preset = "slow";
      
      population.population[i].mutate(preset);
      population.display(i);

      fitness = population.calFitness();

      //if before draw is better, rollback
      if (fitness < lastFitness || (fitness > 2000000 && random(40) < 4) || (fitness > 1500000 && random(50) < 3) || (fitness > 1000000 && random(500) < 2) ) {
        population.copyFromOrigToBack();
        lastFitness = fitness;
      } else {
        population.copyFromBackToOrig();
        fitness = lastFitness;
      }
    }

    if (fitness < originFitness) {
      population.copyFromOriginToBack();
      originFitness = fitness;
    } else {
      population.copyFromBackToOrigin();
      fitness = originFitness;
      gen--;
    }

    gen++;

    image(target, 0, 0);
    image(canvas, 0, target.height);
    TableRow newRow = table.addRow();
    newRow.setInt("Gen", gen);
    newRow.setInt("Time", millis());
    newRow.setInt("Fitness", fitness);
  } else {
    exit();
    noLoop();
  }

  displayInfo();
}

void displayInfo() {

  //display generation count
  textSize(14);
  fill(0);
  rect(0, 5 + 2*target.height, target.width, 60);
  fill(255);
  text("Gen: " + gen, 6, 20 + 2*target.height);
  text("Time: " + millis()/1000 + "." + (millis()%1000)/10, 6, 40 + 2*target.height);
  text("Fitness: " + fitness, 6, 60 + 2*target.height);
}

void keyPressed() {
  if ( key == 'q' || key == 'Q' || key == 'ㅂ') {
    println("starting ending sequence");
    ifContinue = false;
  }
}


void exit() {
  saveTable(table, "data/data.csv");
  println("saving canvas..");
  canvas.save("data/result.png");
  println("saving dna");


  scanvas.beginDraw();
  scanvas.background(255);
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