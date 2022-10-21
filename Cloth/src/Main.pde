Camera camera;
ArrayList<Cloth> clothes = new ArrayList<Cloth>();

//Create Window
String windowTitle = "Project2";
float ground = 60;
ArrayList<ObstacleSphere> obstacles = new ArrayList<ObstacleSphere>();

void setup()
{
  fullScreen(P3D);
  surface.setTitle(windowTitle);
  camera = new Camera();
  float rad = 25;
  ObstacleSphere obstacle = new MovableObstacleSphere(new Vector3(100, ground - rad, -200), rad);
  obstacles.add(obstacle);
  //Cloth cloth = new Cloth(10, 50, new Vector3(-100,-40,-200), ground);
  Cloth cloth = new Cloth(17, 100, new Vector3(-100,-40,-200), ground);
  cloth.addObstacle(obstacle);
  clothes.add(cloth);
}

void keyPressed()
{
  camera.HandleKeyPressed();
  for(ObstacleSphere obstacle : obstacles){
    obstacle.HandleKeyPressed();
  }
  for(Cloth cloth : clothes){
    cloth.HandleKeyPressed();
  }
}

void keyReleased()
{
  camera.HandleKeyReleased();
  for(ObstacleSphere obstacle : obstacles){
    obstacle.HandleKeyReleased();
  }
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

void drawCloth() {
  for(Cloth cloth : clothes){
    cloth.Draw();
  }
}

void drawObstacle() {
  for(ObstacleSphere obstacle : obstacles){
    pushMatrix();
    fill(255,255,255);
    translate(obstacle.position.x, obstacle.position.y, obstacle.position.z);
    sphere(obstacle.radius);
    popMatrix();
  }
}

void draw() {
  background(255);  
  lights();

  camera.Update(1.0/frameRate);

  for(Cloth cloth : clothes){
    for (int i=0; i < 100; i++){
      cloth.Update(1/(100*frameRate));
    }
  }
  
  drawObstacle();
  drawGround();
  drawCloth();

  for(ObstacleSphere obstacle : obstacles){
    obstacle.Update(camera.getForwardDirection(), camera.getRightDirection(), frameRate);
  }
}
