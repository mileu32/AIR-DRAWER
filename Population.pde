// AIR-DRAWER version 1.1.0 build 4
// Population version 1.1.0 build 4
// DNA version 1.1.0 build 5

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

  // Fitness function
  int calFitness() {

    float rerr, gerr, berr, error;
    int fit = 0;

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
        error = rerr + gerr + berr;
        fit += error;
      }
    }  

    return fit;
  }

  DNA getDNA(int i) {
    return population[i];
  }

  void copyFromOrigToBack() {
    //println("copy From Orig To Back");
    for (int i = 0; i < population.length; i++)
      for (int j = 0; j < dnaSize; j++)
        populationBack[i].genes[j] = population[i].genes[j];
  }

  void copyFromBackToOrig() {
    for (int i = 0; i < population.length; i++)
      for (int j = 0; j < dnaSize; j++)
        population[i].genes[j] = populationBack[i].genes[j];
  }

}  