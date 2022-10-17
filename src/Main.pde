Camera camera;
Fluid water;
ArrayList<Cloth> clothes = new ArrayList<Cloth>();;

//Create Window
String windowTitle = "Project2";
float ground = 60;
ObstacleSphere obstacle;
void setup()
{
  // size(600, 600, P3D);
  fullScreen(P3D);
  surface.setTitle(windowTitle);
  camera = new Camera();
  // water = new Fluid();
  float rad = 25;
  obstacle = new ObstacleSphere(new Vector3(100, ground - rad, -200), rad);
  Cloth cloth = new Cloth(10, 4, new Vector3(-100,-50,-200), ground, 1);
  cloth.addObstacle(obstacle);
  clothes.add(cloth);
}

void keyPressed()
{
  camera.HandleKeyPressed();
  obstacle.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
  obstacle.HandleKeyReleased();
}

void mouseMoved() 
{
  camera.HandleMouseMoved();
}

void mousePressed() 
{
  addCloth();
}

void drawGround() {
  pushMatrix();
  fill(128,128,128);
  translate( 0, ground, 0 );
  box(1000,1,1000);
  popMatrix();
}

void drawFallClothLocation() {
  pushMatrix();
  fill(139,69,19);
  translate( 100, -50, -200);
  box(20,1,20);
  popMatrix();
}

void drawWater() {

}

void drawCloth() {
  for(Cloth cloth : clothes){
    cloth.Draw();
  }
}

void drawObstacle() {
  pushMatrix();
  fill(255,255,255);
  translate(obstacle.position.x, obstacle.position.y, obstacle.position.z);
  sphere(obstacle.radius);
  popMatrix();
}

void addCloth() {
  Cloth cloth = new Cloth(10, 4, new Vector3(100,-50,-200), ground, 0);
  cloth.addObstacle(obstacle);
  clothes.add(cloth);
}

void draw() {
  background(255);  
  lights();

  camera.Update(1.0/frameRate);
  //water.Update(1.0/frameRate);

  for(Cloth cloth : clothes){
    for (int i=0; i < 100; i++){
      cloth.Update(1/(100*frameRate));
    }
  }
  drawFallClothLocation();
  drawObstacle();
  drawGround();
  drawWater();
  drawCloth();

  obstacle.Update(camera.getForwardDirection(), camera.getRightDirection());
}
