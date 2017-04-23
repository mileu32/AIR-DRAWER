// AIR-DRAWER version 1.2.0 beta build 9
// Population version 1.2.0 beta build 6
// DNA version 1.2.0 beta build 11

// A class to describe a population of virtual organisms
// In this case, each organism is just an instance of a DNA object

class Population {

  DNA[] population;          // Array to hold the current population
  DNA[] populationBack;      // Backup population

  int dnaSize;

  color backgroundColor;

  Population(int popNum, int dnaSize) {
    population = new DNA[popNum];
    populationBack = new DNA[popNum];

    this.dnaSize = dnaSize;
    for (int i = 0; i < population.length; i++) {
      population[i] =new DNA(dnaSize);
      populationBack[i] = new DNA(dnaSize);
    }

    backgroundColor = selectBackgroundColor(target);
    backgroundColor = color(249, 239, 227);
  }

  void display(int newDNA) {
    //canvas = c_canvas;
    if (newDNA == 0) {
      c_canvas1.beginDraw();
      c_canvas1.background(backgroundColor);
      c_canvas1.endDraw();
    }

    canvas.beginDraw();

    canvas.image(c_canvas1, 0, 0);
    for (int i = newDNA; i < popmax; i++) {
      population[i].draw(canvas);
    }
    canvas.endDraw();
  }

  void mutate() {

    for (int i = 0; i < population.length; i++) {
      population[i].mutate(preset);
    }
  }

  void savefile() {
    PrintWriter output = createWriter("projects/" + projectName + "/dna.air");

    output.println("MILEUAIR v1.0.0");     //file version
    output.println("#256");                //Optimized resolution

    for (int i = 0; i < population.length; i++)
      output.println(populationBack[i].toString());

    output.flush(); // Writes the remaining data to the file
    output.close();
  }

  // Fitness function
  int[] calFitness() {

    float rerr, gerr, berr;
    int[] fit = new int[3];// r, g, b

    for (int x = 0; x < target.width; x++) {
      for (int y = 0; y < target.height; y++) {
        int loc = x + y*target.width;
        //int comploc = x + (y+(target.height))*target.width;
        color sourcepix = target.pixels[loc];
        color comparepix = canvas.pixels[loc];

        //find the error in color (0 to 255, 0 is no error)
        rerr = abs(red(sourcepix)-red(comparepix));
        gerr = abs(green(sourcepix)-green(comparepix));
        berr = abs(blue(sourcepix)-blue(comparepix));
        fit[0] += rerr;
        fit[1] += gerr;
        fit[2] += berr;
      }
    }  

    return fit;
  }

  DNA getDNA(int i) {
    return population[i];
  }

  void copyFromOrigToBack() {
    for (int i = 0; i < population.length; i++)
      for (int j = 0; j < dnaSize; j++)
        populationBack[i].genes[j] = population[i].genes[j];
  }

  void copyFromOrigToBack(int target) {
    for (int j = 0; j < dnaSize; j++)
      populationBack[target].genes[j] = population[target].genes[j];
  }

  void copyFromBackToOrig() {
    for (int i = 0; i < population.length; i++)
      for (int j = 0; j < dnaSize; j++)
        population[i].genes[j] = populationBack[i].genes[j];
  }

  void copyFromBackToOrig(int target) {
    for (int j = 0; j < dnaSize; j++)
      population[target].genes[j] = populationBack[target].genes[j];
  }

  void copyFromBackToOrig(int target, int rgb) { // 0 : red, 1 : green, 2 : blue
    population[target].genes[rgb] = populationBack[target].genes[rgb];
  }
}  