// AIR-DRAWER version 1.0.0 build 1
// Canvas version 1.0.0 build 1
// DNA version 1.0.0 build 1

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

    genes[7] = 80;
  }

  void mutate(String preset) {
    if (preset.equals("fast")) {

      genes[0]=constrain(genes[0] + target.width * randomGaussian() / 20, 1, target.width);
      genes[1]=constrain(genes[1] + target.height * randomGaussian() / 20, 1, target.height);

      genes[2]=constrain(genes[2] + target.width * randomGaussian() / 20, 1, target.width);
      genes[3]=constrain(genes[3] + target.height * randomGaussian() / 20, 1, target.height);

      genes[4]=constrain(genes[4] + 255 * randomGaussian() / 15, 0, 255);
      genes[5]=constrain(genes[5] + 255 * randomGaussian() / 15, 0, 255);
      genes[6]=constrain(genes[6] + 255 * randomGaussian() / 15, 0, 255);
      
    } else if (preset.equals("medium")) {

      genes[0]=constrain(genes[0] + target.width * randomGaussian() / 40, 1, target.width);
      genes[1]=constrain(genes[1] + target.height * randomGaussian() / 40, 1, target.height);

      genes[2]=constrain(genes[2] + target.width * randomGaussian() / 40, 1, target.width);
      genes[3]=constrain(genes[3] + target.height * randomGaussian() / 40, 1, target.height);

      genes[4]=constrain(genes[4] + 255 * randomGaussian() / 30, 0, 255);
      genes[5]=constrain(genes[5] + 255 * randomGaussian() / 30, 0, 255);
      genes[6]=constrain(genes[6] + 255 * randomGaussian() / 30, 0, 255);
      
    } else if (preset.equals("slow")) {

      genes[0]=constrain(genes[0] + target.width * randomGaussian() / 80, 1, target.width);
      genes[1]=constrain(genes[1] + target.height * randomGaussian() / 80, 1, target.height);

      genes[2]=constrain(genes[2] + target.width * randomGaussian() / 80, 1, target.width);
      genes[3]=constrain(genes[3] + target.height * randomGaussian() / 80, 1, target.height);

      genes[4]=constrain(genes[4] + 255 * randomGaussian() / 60, 0, 255);
      genes[5]=constrain(genes[5] + 255 * randomGaussian() / 60, 0, 255);
      genes[6]=constrain(genes[6] + 255 * randomGaussian() / 60, 0, 255);
      
    } else mutate(); // default option
  }

  void mutate() {

    genes[0]=constrain(genes[0] + target.width * randomGaussian() / 20, 1, target.width);
    genes[1]=constrain(genes[1] + target.height * randomGaussian() / 20, 1, target.height);

    genes[2]=constrain(genes[2] + target.width * randomGaussian() / 20, 1, target.width);
    genes[3]=constrain(genes[3] + target.height * randomGaussian() / 20, 1, target.height);

    genes[4]=constrain(genes[4] + 255 * randomGaussian() / 15, 0, 255);
    genes[5]=constrain(genes[5] + 255 * randomGaussian() / 15, 0, 255);
    genes[6]=constrain(genes[6] + 255 * randomGaussian() / 15, 0, 255);
    
  }

  void draw(PGraphics cacheBoard) {
    
    //draw polygon on screen based on parameters
    draw(cacheBoard, 1);
    
  }

  void draw(PGraphics cacheBoard, float ratio) {
    
    cacheBoard.stroke(genes[4], genes[5], genes[6], genes[7]);
    cacheBoard.strokeWeight(2 * ratio);
    cacheBoard.line(genes[0] * ratio, genes[1] * ratio, genes[2] * ratio, genes[3] * ratio);
    
  }
  
}