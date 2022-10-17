Camera camera;
Fluid water;
Cloth cloth;

//Create Window
String windowTitle = "Project2";
void setup()
{
  // size(600, 600, P3D);
  fullScreen(P3D);
  surface.setTitle(windowTitle);
  camera = new Camera();
  // water = new Fluid();
  cloth = new Cloth();
}

void keyPressed()
{
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
}

void mouseMoved() {
  camera.HandleMouseMoved();
}

void drawCubes(){
  // draw six cubes surrounding the origin (front, back, left, right, top, bottom)
  fill( 0, 0, 255 );
  pushMatrix();
  translate( 0, 0, -50 );
  box( 20 );
  popMatrix();
  
  pushMatrix();
  translate( 0, 0, 50 );
  box( 20 );
  popMatrix();
  
  fill( 255, 0, 0 );
  pushMatrix();
  translate( -50, 0, 0 );
  box( 20 );
  popMatrix();
  
  pushMatrix();
  translate( 50, 0, 0 );
  box( 20 );
  popMatrix();
  
  fill( 0, 255, 0 );
  pushMatrix();
  translate( 0, 50, 0 );
  box( 20 );
  popMatrix();
  
  pushMatrix();
  translate( 0, -50, 0 );
  box( 20 );
  popMatrix();
}

void drawGround() {

}

void drawWater() {

}

void drawCloth() {
  cloth.Draw();
}

void draw() {
  background(255);
  noLights();

  camera.Update(1.0/frameRate);
  //water.Update(1.0/frameRate);

  for (int i=0; i < 100; i++){
    cloth.Update(1/(100*frameRate));
  }
  // drawCubes();
  drawGround();
  drawWater();
  drawCloth();
}
