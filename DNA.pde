// AIR-DRAWER version 1.1.0 build 3
// Population version 1.0.0 build 1
// DNA version 1.0.1 build 4

class DNA {

  // The genetic sequence
  float[] genes;//(x1,y1), (x2,y2), r, g, b, a;
  int dnaSize;
  float fitness;

  // Constructor (makes a random DNA)
  DNA(int num) {
    this.dnaSize = num;
    float len = target.width;
    genes = new float[dnaSize];

    //do not create too long line at first
    while (len > target.width / 2) {
      genes[0] = random(0, target.width);
      genes[1] = random(0, target.height);

      genes[2] = random(0, target.width);
      genes[3] = random(0, target.height);

      len = sqrt((genes[0] - genes[2]) * (genes[0] - genes[2]) + (genes[1] - genes[3]) * (genes[1] - genes[3]));
    }

    //create random fill color and define alpha
    genes[4] = random(1, 255);
    genes[5] = random(1, 255);
    genes[6] = random(1, 255);

    genes[7] = 48;
  }

  void mutate(int xy, int rgb) {
    genes[0]=constrain(genes[0] + target.width * randomGaussian() / xy, 1, target.width);
    genes[1]=constrain(genes[1] + target.height * randomGaussian() / xy, 1, target.height);

    genes[2]=constrain(genes[2] + target.width * randomGaussian() / xy, 1, target.width);
    genes[3]=constrain(genes[3] + target.height * randomGaussian() / xy, 1, target.height);

    genes[4]=constrain(genes[4] + 255 * randomGaussian() / rgb, 0, 255);
    genes[5]=constrain(genes[5] + 255 * randomGaussian() / rgb, 0, 255);
    genes[6]=constrain(genes[6] + 255 * randomGaussian() / rgb, 0, 255);
  }

  // presets
  void mutate(String preset) {

    if (preset.equals("UltraFast")) {
      mutate(20, 15);
    } else if (preset.equals("SuperFast")) {
      mutate(30, 20);
    } else if (preset.equals("VeryFast")) {
      mutate(40, 25);
    } else if (preset.equals("Faster")) {
      mutate(50, 30);
    } else if (preset.equals("Fast")) {
      mutate(60, 35);
    } else if (preset.equals("Medium")) {
      mutate(70, 40);
    } else if (preset.equals("Slow")) {
      mutate(80, 45);
    } else if (preset.equals("Slower")) {
      mutate(90, 50);
    } else if (preset.equals("VerySlow")) {
      mutate(100, 55);
    } else if (preset.equals("Placebo")) {
      mutate(110, 60);
    } else mutate();
  }

  // default option
  void mutate() {
    mutate(20, 15);
  }

  void draw(PGraphics cacheBoard, float ratio) {
    cacheBoard.stroke(genes[4], genes[5], genes[6], genes[7]);
    cacheBoard.strokeWeight(2 * ratio);
    cacheBoard.line(genes[0] * ratio, genes[1] * ratio, genes[2] * ratio, genes[3] * ratio);
  }

  void draw(PGraphics cacheBoard) {
    draw(cacheBoard, 1);
  }
}