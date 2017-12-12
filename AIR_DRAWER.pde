// AIR-DRAWER version 1.3.0 build 19
// Population version 1.3.0 build 15
// DNA version 1.3.0 build 12

import org.hyperic.sigar.Sigar;
import org.hyperic.sigar.Mem;
import org.hyperic.sigar.SigarException;

//data of times and fitness
Table table = new Table();
PrintWriter log;

Boolean ifContinue = true;
int endCount = 0;
int addPopCount = 0;

PFont f;

int dnaSize;
Population population;

int gen;

String preset = "Medium";

String projectName = year() + "00".substring(str(month()).length()) + str(month()) + "00".substring(str(day()).length()) + str(day()) + "00".substring(str(hour()).length()) + str(hour()) + "00".substring(str(minute()).length()) + str(minute()) + "_AIR";

ArrayList<String> print = new ArrayList<String>();

void setup() {
  size(1080, 608);

  //pixelDensity(displayDensity());

  noStroke();
  smooth();

  f = createFont("font/Maplestory Light.ttf", 50, true);

  surface.setTitle("AIR-DRAWER v1.3.0");

  table.addColumn("Gen");
  table.addColumn("Time");
  table.addColumn("Fitness");
  table.addColumn("Success");

  int popmax = 100;
  dnaSize = 8;

  background(127);

  // Create a populationation with a target , mutation rate, and populationation max
  PImage target;
  target = loadImage("sagiri256.png");
  population = new Population(popmax, dnaSize, target);

  PImage mileuIcon;
  mileuIcon = loadImage("mileu.png");

  image(target, 32, 32);

  fill(192);
  rect(256 + 64, 32, 256, 256);
  image(mileuIcon, 256 + 64, 32, 256, 256);

  log = createWriter(".log.txt");
  log.println("Log created date : "+year()+"/"+month()+"/"+day()+" "+hour()+":"+minute()+":"+second()+"."+millis());
  log.println(projectName);

  printM("AIR-DRAWER version 1.3.0 build 19");
}

void draw() {
  if (millis() > 60000 && millis() < 100000) displaySystemInfo(256 + 64, 32, 256, 256);

  if (ifContinue) {

    printM("preset : " + preset);

    if (addPopCount > 0) {

      if (addPopCount > 350) preset = "UltraFast";
      else if (addPopCount > 100) preset = "Medium";
      else if (addPopCount > 1) preset = "Color";
      else preset = "Medium";

      population.mutate(population.getPopLength() - 50);
      addPopCount -= 1;
    } else {

      population.mutate();
      if (preset.equals("Medium") & population.getSuccess() < 5 & population.popLength < 3000) {
        population.addPop(50);
        addPopCount = 400;
      }
    }

    gen++;

    image(population.getCanvas(), 32, population.getTarget().height + 64);
    TableRow newRow = table.addRow();
    newRow.setInt("Gen", gen);
    newRow.setInt("Time", millis());
    newRow.setInt("Fitness", population.getFitness());
    newRow.setInt("Success", population.getSuccess());

    displayDiff(256 + 64, 256 + 64, 256, 256);
    displayInfo(256 * 2 + 32 * 3, 32, 440, 32);
    displayPrintM(256 * 2 + 32 * 3, 32 *3, 440, 480);
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
  textFont(f, 19);
  fill(192);
  rect(x1 + 128, y1 + 128, 128, 128);
  fill(255, 0, 0);
  text("R : " + String.format("%.2E", population.getFitrgb()[0] / 1.0), x1 + 128 + 6, y1 + 128 + 32);
  fill(0, 255, 0);
  text("G : " + String.format("%.2E", population.getFitrgb()[1] / 1.0), x1 + 128 + 6, y1 + 128 + 64);
  fill(0, 0, 255);
  text("B : " + String.format("%.2E", population.getFitrgb()[2] / 1.0), x1 + 128 + 6, y1 + 128 + 96);
}

void displaySystemInfo(int x1, int y1, int x2, int y2) {

  fill(192);
  rect(x1, y1, x2, y2);

  textAlign(CENTER, CENTER);
  textFont(f, 30);
  fill(0);

  text("AIR-DRAWER", x1 + x2 / 2, y1 + 30);

  textFont(f, 20);
  fill(0);

  text("v1.3.0", x1 + x2 / 2, y1 + 60);

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

void displayPrintM(int x1, int y1, int x2, int y2) {
  textAlign(LEFT, CENTER);
  textFont(f, 20);
  fill(0);
  rect(x1, y1, x2, y2);
  fill(255);
  while (print.size() > 18)
    print.remove(0);

  for (int i = 0; i < print.size(); i++) {
    text(print.get(print.size() - i - 1), x1 + 10, y1 + 480 - 20 - 25 * i);
  }
}

void printM(String message) {
  System.out.println(message);
  log.println(message);
  log.flush();
  print.add(message);
}

void displayInfo(int x1, int y1, int x2, int y2) {

  //display on console
  printM("success " + population.getSuccess() + "  DNA SIZE " + population.getPopLength());
  int[] fitrgb = population.getFitrgb();
  printM(fitrgb[0] + " : " + fitrgb[1] + " : " + fitrgb[2]);

  //display generation count
  textAlign(LEFT, CENTER);
  textFont(f, 19); 

  fill(0);
  rect(x1, y1, x2, y2);
  fill(0, 255, 255);

  String hour = "00";
  String minute = "00";
  String second = "00";

  hour = "00".substring(str(millis()/3600000).length()) + str(millis()/3600000);
  minute = "00".substring(str((millis()/60000)%60).length()) + str((millis()/60000)%60);
  second = "00".substring(str((millis()/1000)%60).length()) + str((millis()/1000)%60);

  text("세대 : " + gen + "   시간 : " + hour + ":" + minute + ":" + second + "   정밀도 : " + String.format("%.3E",  population.getFitness() / 3.0), x1 + 5, y1 + 13);
}

void keyPressed() {
  if ( key == 'q' || key == 'Q' || key == 'ㅂ') {
    printM("starting ending sequence");
    ifContinue = false;
  } else if ( key == '1') {
    preset = "UltraFast";
    printM("UltraFast");
  } else if ( key == '2') {
    preset = "SuperFast";
    printM("SuperFast");
  } else if ( key == '3') {
    preset = "VeryFast";
    printM("VeryFast");
  } else if ( key == '4') {
    preset = "Faster";
    printM("Faster");
  } else if ( key == '5') {
    preset = "Fast";
    printM("Fast");
  } else if ( key == '6') {
    preset = "Medium";
    printM("Medium");
  } else if ( key == '7') {
    preset = "Slow";
    printM("Slow");
  } else if ( key == '8') {
    preset = "Slower";
    printM("Slower");
  } else if (key == '9' ) {
    preset = "VerySlow";
    printM("VerySlow");
  } else if (key == '0' ) {
    preset = "Placebo";
    printM("Placebo");
  } else if ( key == '!') {
    preset = "UltraFast(noRGB)";
    printM("UltraFast(noRGB)");
  } else if ( key == '@') {
    preset = "SuperFast(noRGB)";
    printM("SuperFast(noRGB)");
  } else if ( key == '#') {
    preset = "VeryFast(noRGB)";
    printM("VeryFast(noRGB)");
  } else if ( key == '$') {
    preset = "Faster(noRGB)";
    printM("Faster(noRGB)");
  } else if ( key == '%') {
    preset = "Fast(noRGB)";
    printM("Fast(noRGB)");
  } else if ( key == '^') {
    preset = "Medium(noRGB)";
    printM("Medium(noRGB)");
  } else if ( key == '&') {
    preset = "Slow(noRGB)";
    printM("Slow(noRGB)");
  } else if ( key == '*') {
    preset = "Slower(noRGB)";
    printM("Slower(noRGB)");
  } else if (key == '(' ) {
    preset = "VerySlow(noRGB)";
    printM("VerySlow(noRGB)");
  } else if (key == ')' ) {
    preset = "Placebo(noRGB)";
    printM("Placebo(noRGB)");
  } else if (key == 'c' ) {
    preset = "Color";
    printM("Color");
  }
}

void exit() {

  saveTable(table, "projects/" + projectName + "/data.csv");

  //population.removePop();

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
    printM(i + "/" + population.getPopLength());
    scanvas.save("projects/" + projectName + "/draw/" + count + ".jpg");
  }

  scanvas.save("projects/" + projectName + "/result(16x).png");
}