// AIR-DRAWER version 1.2.0 beta build 8
// Population version 1.1.0 build 4
// DNA version 1.2.0 beta build 8

class DNA {

  // The genetic sequence
  float[] genes;//(x1,y1), (x2,y2), r, g, b, a;
  int dnaSize;
  float fitness;

  // Constructor (makes a random DNA)
  DNA(int num) {
    this.dnaSize = num;
    genes = new float[dnaSize];

    //x, y coordinate ratio
    genes[0] = random(1);
    genes[1] = random(1);

    genes[2] = random(1);
    genes[3] = random(1);

    //create random fill color and define alpha
    genes[4] = random(0, 255);
    genes[5] = random(0, 255);
    genes[6] = random(0, 255);

    genes[7] = 64;
  }

  void mutate(int xy, int rgb) {
    if (xy > 0 && rgb >0) {
      genes[0]=constrain(genes[0] + randomGaussian() / xy, 0, 1);
      genes[1]=constrain(genes[1] + randomGaussian() / xy, 0, 1);

      genes[2]=constrain(genes[2] + randomGaussian() / xy, 0, 1);
      genes[3]=constrain(genes[3] + randomGaussian() / xy, 0, 1);

      genes[4]=constrain(genes[4] + 255 * randomGaussian() / rgb, 0, 255);
      genes[5]=constrain(genes[5] + 255 * randomGaussian() / rgb, 0, 255);
      genes[6]=constrain(genes[6] + 255 * randomGaussian() / rgb, 0, 255);
    } else if (xy < 0 && rgb >0) {
      genes[4]=constrain(genes[4] + 255 * randomGaussian() / rgb, 0, 255);
      genes[5]=constrain(genes[5] + 255 * randomGaussian() / rgb, 0, 255);
      genes[6]=constrain(genes[6] + 255 * randomGaussian() / rgb, 0, 255);
    } else if (xy > 0 && rgb <0) {
      genes[0]=constrain(genes[0] + randomGaussian() / xy, 0, 1);
      genes[1]=constrain(genes[1] + randomGaussian() / xy, 0, 1);

      genes[2]=constrain(genes[2] + randomGaussian() / xy, 0, 1);
      genes[3]=constrain(genes[3] + randomGaussian() / xy, 0, 1);
    }
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
    } else if (preset.equals("UltraFast(noRGB)")) {
      mutate(20, -1);
    } else if (preset.equals("SuperFast(noRGB)")) {
      mutate(30, -1);
    } else if (preset.equals("VeryFast(noRGB)")) {
      mutate(40, -1);
    } else if (preset.equals("Faster(noRGB)")) {
      mutate(50, -1);
    } else if (preset.equals("Fast(noRGB)")) {
      mutate(60, -1);
    } else if (preset.equals("Medium(noRGB)")) {
      mutate(70, -1);
    } else if (preset.equals("Slow(noRGB)")) {
      mutate(80, -1);
    } else if (preset.equals("Slower(noRGB)")) {
      mutate(90, -1);
    } else if (preset.equals("VerySlow(noRGB)")) {
      mutate(100, -1);
    } else if (preset.equals("Placebo(noRGB)")) {
      mutate(110, -1);
    } else if (preset.equals("Color")) {
      mutate(-1, 40);
    } else mutate();
  }

  // default option
  void mutate() {
    mutate(20, 15);
  }

  void draw(PGraphics cacheBoard, float ratio) {
    cacheBoard.stroke(genes[4], genes[5], genes[6], genes[7]);
    cacheBoard.strokeWeight(2 * ratio);
    cacheBoard.line(genes[0] * 128 * ratio, genes[1] * 128 * ratio, genes[2] * 128 * ratio, genes[3] * 128 * ratio);
  }

  void draw(PGraphics cacheBoard) {
    float ratio;
    ratio = cacheBoard.width / 128;
    draw(cacheBoard, ratio);
  }
}