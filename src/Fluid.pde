class Fluid
{
  float leftX;
  float rightX;
  float bottomY;
  float topY;
  float frontZ;
  float backZ;
  float x;
  float y;
  float z = 10.0f; // set this to null
  final float eachXSize = 20.0f;
  final float eachZSize = 20.0f;
  float lastXSize;
  float lastZSize;
  int totalXRectangle;
  // int totalZRectangle;
  // Rectangle[][] rectangles;
  Rectangle[] rectangles;
  RGB rgb = new RGB(156,211,219);


  Fluid(float leftX, float rightX, float bottomY, float topY, float frontZ, float backZ) {
    this.leftX = leftX;
    this.rightX = rightX;
    this.bottomY = bottomY;
    this.topY = topY;
    this.frontZ = frontZ;
    this.backZ = backZ;
    x = rightX - leftX;
    y = bottomY - topY;
    // z = frontZ - backZ;
    totalXRectangle = (int) (x/eachXSize);
    // totalZRectangle = (int) (z/eachZSize);
    lastXSize = x - (eachXSize * totalXRectangle);
    // lastZSize = z - (eachZSize * totalZRectangle);
    // rectangles = new Rectangle[totalXRectangle][totalZRectangle];
    rectangles = new Rectangle[totalXRectangle];
    initScene();
  }

  void initScene(){
    for(int i = 0; i < totalXRectangle; i++){
      float xPos = leftX + ((float) (i) * eachXSize);
      // float zPos = frontZ + ((float) (i) * eachZSize);
      float zPos = frontZ + (z/2.0f);
      if(i == totalXRectangle){ // last rectangle, different position and size
        xPos += lastXSize/2.0f;
      } else {
        xPos += eachXSize/2.0f;
      }

      // HERE check if the rectangle is the end z, if so then set the zPos to lastZSize
      
      Vector3 position = new Vector3(xPos, 0, zPos);
      // Vector3 size = new Vector3(eachXSize, y, eachZSize);
      Vector3 size = new Vector3(eachXSize, y, z);

      if(i == totalXRectangle) size.x = lastXSize;
      // if(j == totalZRectangle) size.z = lastZSize;
      
      rectangles[i] = new Rectangle(position, size, rgb);
    }
  }

  void drawFluid(){
    for(int i = 0; i < totalXRectangle; i++){
      
    }
  }

  void Update(){
    //calculate();
    drawFluid();
  }

}
