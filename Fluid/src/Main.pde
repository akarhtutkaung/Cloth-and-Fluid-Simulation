Camera camera;
Fluid water;

//Create Window
String windowTitle = "Project2";
float ground = 60;
ArrayList<ObstacleSphere> obstacles = new ArrayList<ObstacleSphere>();

// Fluid bounding box
float leftX = -230;
float rightX = 230;
float backZ = -730; 
float frontZ = -270;

void setup()
{
  fullScreen(P3D);
  surface.setTitle(windowTitle);
  camera = new Camera();
  water = new Fluid(leftX, rightX, frontZ, backZ, ground);
}

void keyPressed()
{
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
}

void mouseMoved() 
{
  camera.HandleMouseMoved();
}

void mousePressed()
{
  createObstacleForFluid();
}

void createObstacleForFluid(){
  Vector3 position = new Vector3(leftX + (rightX - leftX)/2, ground - 40, frontZ + (backZ - frontZ)/2);
  ObstacleSphere obstacle = new NonmovableObstacleSphere(position, 5, ground);
  obstacles.add(obstacle);
  water.addObstacle(obstacle);
}

void drawGround() {
  pushMatrix();
  fill(128,128,128);
  translate( 0, ground, 0 );
  box(500,1,500);
  popMatrix();
}

void drawWater() {
  water.Draw();
}

void drawObstacle() {
  for(ObstacleSphere obstacle : obstacles){
    pushMatrix();
    fill(255,0,0);
    translate(obstacle.position.x, obstacle.position.y, obstacle.position.z);
    // sphere(obstacle.radius);
    box(obstacle.radius, obstacle.radius, 460);
    popMatrix();
  }
}

void drawPoolBorder() {
  fill(178, 190, 181);
  // Front border
  pushMatrix();
  translate( 0, ground, -260 );
  box(500,8,20);
  popMatrix();

  // Back border
  pushMatrix();
  translate( 0, ground, -740 );
  box(500,8,20);
  popMatrix();

  // Right border
  pushMatrix();
  translate( 240, ground, -500 );
  box(20,8,460);
  popMatrix();

  // Left border
  pushMatrix();
  translate( -240, ground, -500 );
  box(20,8,460);
  popMatrix();
  
}

void draw() {
  background(255);  
  lights();
  
  // Camera
  camera.Update(1.0/frameRate);

  // Swimming pool
  drawPoolBorder();
  pushMatrix();
  // noLights();
  directionalLight(255, 255, 255, 0, 1, -1);
  for(int i=0; i<10; i++){
    water.Update(1.0/(frameRate));
    drawWater();
  }
  popMatrix();
  
  // Obstacles
  drawObstacle();
  for(ObstacleSphere obstacle : obstacles){
    obstacle.Update(camera.getForwardDirection(), camera.getRightDirection(), 1.0/frameRate);
  }

  // Ground
  drawGround();
}
