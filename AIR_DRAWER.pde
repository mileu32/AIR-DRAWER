// AIR-DRAWER version 1.3.0 beta build 17
// Population version 1.3.0 beta build 12
// DNA version 1.2.0 build 11

//data of times and fitness

import org.hyperic.sigar.Sigar;
import org.hyperic.sigar.Mem;
import org.hyperic.sigar.SigarException;

Table table = new Table();

Boolean ifContinue = true;
int endCount = 0;
int addPopCount = 0;

PFont f;

int dnaSize;
Population population;

int gen;

String preset = "UltraFast";

String projectName = year() + "00".substring(str(month()).length()) + str(month()) + "00".substring(str(day()).length()) + str(day()) + "00".substring(str(hour()).length()) + str(hour()) + "00".substring(str(minute()).length()) + str(minute()) + "_AIR";

void setup() {
  size(1080, 608);

  //pixelDensity(displayDensity());

  noStroke();
  smooth();

  f = createFont("Courier", 50, true);

  surface.setTitle("AIR-DRAWER v1.3.0 beta");

  table.addColumn("Gen");
  table.addColumn("Time");
  table.addColumn("Fitness");
  table.addColumn("Success");

  int popmax = 100;
  dnaSize = 8;

  background(127);

  // Create a populationation with a target , mutation rate, and populationation max
  PImage target;
  target = loadImage("xp.jpg");
  population = new Population(popmax, dnaSize, target);

  PImage mileuIcon;
  mileuIcon = loadImage("mileu.png");

  fill(255);

  image(target, 32, 32);

  rect(256 + 64, 32, 256, 256);
  image(mileuIcon, 256 + 64, 32, 256, 256);
  
}

void draw() {
  if(millis() > 10000 && millis() < 100000) displaySystemInfo(256 + 64, 32, 256, 256);

  if (ifContinue) {

    if (addPopCount > 0) {

      if (addPopCount > 300) preset = "UltraFast";
      else if (addPopCount > 100) preset = "Medium";
      else if (addPopCount > 1) preset = "Color";
      else preset = "UltraFast";

      population.mutate(population.getPopLength() - 50);
      addPopCount -= 1;
    } else {
      population.mutate();
      if (preset.equals("UltraFast") & population.getSuccess() < 5) {
        population.addPop(50);
        addPopCount = 600;
      }
    }

    gen++;

    image(population.getCanvas(), 32, population.getTarget().height + 64);
    TableRow newRow = table.addRow();
    newRow.setInt("Gen", gen);
    newRow.setInt("Time", millis());
    newRow.setInt("Fitness", population.getFitness());
    newRow.setInt("Success", population.getSuccess());

    displayInfo(population.getTarget().width * 2 + 64, population.getTarget().height, population.getTarget().width * 2, 32);
    displayDiff(256 + 64, 256 + 64, 256, 256);
  } else {
    exit();
    noLoop();
  }

  saveFrame("projects/" + projectName + "/frames/#####.jpg");
}

void displayDiff(int x1, int y1, int x2, int y2) {
  PImage[] diffImage = population.diffImage();
  image(diffImage[0], x1, y1, 128, 128);
  image(diffImage[1], x1 + 128, y1, 128, 128);
  image(diffImage[2], x1, y1 + 128, 128, 128);

  textAlign(LEFT, CENTER);
  textFont(f, 20);
  fill(192);
  rect(x1 + 128, y1 + 128, 128, 128);
  fill(255, 0, 0);
  text("R : " + population.getFitrgb()[0], x1 + 128 + 10, y1 + 128 + 32);
  fill(0, 255, 0);
  text("G : " + population.getFitrgb()[1], x1 + 128 + 10, y1 + 128 + 64);
  fill(0, 0, 255);
  text("B : " + population.getFitrgb()[2], x1 + 128 + 10, y1 + 128 + 96);
}

void displaySystemInfo(int x1, int y1, int x2, int y2) {

  fill(192);
  rect(x1, y1, x2, y2);

  textAlign(CENTER, CENTER);
  textFont(f, 30);
  fill(0);

  text("AIR-DRAWER", x1 + x2 / 2, y1 + 30);
  
  textFont(f, 20);
  fill(255, 0, 0);
  
  text("v1.3.0b", x1 + x2 / 2, y1 + 60);

  String cpu = "";

  try {
    Sigar sigar = new Sigar();
    org.hyperic.sigar.CpuInfo[] cpuInfoList = sigar.getCpuInfoList();
    for (org.hyperic.sigar.CpuInfo info : cpuInfoList)
      cpu = info.getModel();
  } 
  catch (Exception e) {
  }

  textAlign(LEFT, CENTER);
  textFont(f, 20);
  fill(0);

  text("System", x1 + 10, y1 + 125);
  
  textFont(f, 13);
  text("CPU : " + cpu, x1 + 5, y1 + 155);
  text("RAM : " + Runtime.getRuntime().maxMemory()/pow(2, 30) + " GB", x1 + 5, y1 + 180);
  text("OS : " + System.getProperty("os.name") + " " + System.getProperty("os.version") + " " + System.getProperty("os.arch"), x1 + 5, y1 + 205);
  text("JAVA : " + System.getProperty("java.vendor") + " " + System.getProperty("java.version"), x1 + 5, y1 + 230);
}


void displayInfo(int x1, int y1, int x2, int y2) {

  //display on console
  println("success " + population.getSuccess() + "  DNA SIZE " + population.getPopLength());
  int[] fitrgb = population.getFitrgb();
  println(fitrgb[0] + " : " + fitrgb[1] + " : " + fitrgb[2]);

  //display generation count
  textAlign(LEFT, CENTER);
  textFont(f, 20); 

  fill(0);
  rect(x1, y1, x2, y2);
  fill(0, 255, 255);
  text("Gen : " + gen, x1 + 10, y1 + 14);
  String hour = "00";
  String minute = "00";
  String second = "00";

  hour = "00".substring(str(millis()/3600000).length()) + str(millis()/3600000);
  minute = "00".substring(str((millis()/60000)%60).length()) + str((millis()/60000)%60);
  second = "00".substring(str((millis()/1000)%60).length()) + str((millis()/1000)%60);

  text("시간 : " + hour + ":" + minute + ":" + second, x1 + 150, y1 + 14);
  text("정밀도 : " + population.getFitness() / 3, x1 + 330, y1 + 14);
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

  population.savefile();

  PGraphics scanvas; //Ga drawing render

  scanvas = createGraphics(population.getTarget().width * 16, population.getTarget().height * 16);
  scanvas.smooth();
  scanvas.beginDraw();
  scanvas.noStroke();
  scanvas.background(population.backgroundColor);
  scanvas.endDraw();

  for (int i = 0; i < population.getPopLength(); i++) {
    scanvas.beginDraw();
    population.population[i].draw(scanvas);
    scanvas.endDraw();
    String count = "00000".substring(str(i).length()) + str(i);
    println(i + "/" + population.getPopLength());
    scanvas.save("projects/" + projectName + "/draw/" + count + ".jpg");
  }

  scanvas.save("projects/" + projectName + "/result(16x).png");
}