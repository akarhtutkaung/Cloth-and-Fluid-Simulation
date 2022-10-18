Camera camera;
Fluid water;
ArrayList<Cloth> clothes = new ArrayList<Cloth>();;

//Create Window
String windowTitle = "Project2";
float ground = 60;
ObstacleSphere obstacle;
void setup()
{
  fullScreen(P3D);
  surface.setTitle(windowTitle);
  camera = new Camera();
  water = new Fluid(-50, 50, -350, -400, ground);
  float rad = 25;
  obstacle = new ObstacleSphere(new Vector3(100, ground - rad, -200), rad);
  Cloth cloth = new Cloth(10, 50, new Vector3(-100,-40,-200), ground);
  cloth.addObstacle(obstacle);
  clothes.add(cloth);
}

void keyPressed()
{
  camera.HandleKeyPressed();
  obstacle.HandleKeyPressed();
  for(Cloth cloth : clothes){
    cloth.HandleKeyPressed();
  }
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

void drawGround() {
  pushMatrix();
  fill(128,128,128);
  translate( 0, ground, 0 );
  box(1000,1,1000);
  popMatrix();
}

void drawWater() {
  water.Draw();
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

void draw() {
  background(255);  
  lights();

  camera.Update(1.0/frameRate);
  for(int i=0; i<10; i++){
    water.Update(1.0/frameRate);
  drawWater();
  }

  for(Cloth cloth : clothes){
    for (int i=0; i < 100; i++){
      cloth.Update(1/(100*frameRate));
    }
  }
  
  drawObstacle();
  drawGround();
  drawCloth();

  obstacle.Update(camera.getForwardDirection(), camera.getRightDirection());
}
