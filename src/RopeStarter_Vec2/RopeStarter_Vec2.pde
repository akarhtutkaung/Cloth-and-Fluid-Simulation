
float obstacleSpeed = 300;
//Create Window
String windowTitle = "Swinging Rope";


Vector2 obstacleVel = new Vector2(0,0);

//Simulation Parameters
float floor = 500;
Vector2 gravity = new Vector2(0,400);
float radius = 5;
Vector2 stringTop = new Vector2(200,50);
float restLen = 10;
float mass = 1;
float k = 300;
float kv = 100;

float circleRad = 50;

//Initial positions and velocities of masses
static int maxVerticalNodes = 14;
static int maxHorizontalNodes = 20;

Node nodes[][] = new Node[maxHorizontalNodes][maxVerticalNodes];
Vector2 circlePos = new Vector2(200,200);

void setup() {
  size(1000, 1000, P3D);
  surface.setTitle(windowTitle);
  initScene();
}

void initScene(){
  for (int i = 0; i < maxHorizontalNodes; i++){
    float xOffset = 0;
    for(int j = 0; j < maxVerticalNodes; j++){
      float x = stringTop.x + xOffset +8*i;
      float y = stringTop.y + 8*i;
      Vector2 pos = new Vector2(x, y);
      nodes[i][j] = new Node(pos);
      xOffset += 25;
    }
  }
}

void update(float dt){

  //Reset accelerations each timestep (momenum only applies to velocity)
  for(int i = 0; i < maxHorizontalNodes; i++){
    for(int j = 0; j < maxVerticalNodes; j++){
      nodes[i][j].resetAcceleration();
      nodes[i][j].resetAccelerationH();
      nodes[i][j].addToAcceleration(gravity);
    }
  }
  
  //Compute (damped) Hooke's law for each spring
  for(int i = 0; i < maxHorizontalNodes-1; i++){
    for(int j = 0; j < maxVerticalNodes; j++){
      Vector2 diff = nodes[i+1][j].position.minus(nodes[i][j].position);
      float stringF = -k*(diff.length() - restLen);
      
      Vector2 stringDir = diff.normalized();
      float projVbot = dot(nodes[i][j].velocity, stringDir);
      float projVtop = dot(nodes[i+1][j].velocity, stringDir);
      float dampF = -kv*(projVtop - projVbot);

      Vector2 force = stringDir.times(stringF+dampF);
      nodes[i][j].addToAcceleration(force.times(-1.0/mass));
      nodes[i+1][j].addToAcceleration(force.times(1.0/mass));
    }
  }  
  
  // Compute (damped) Hooke's law for each spring H
  for(int i = 0; i < maxHorizontalNodes-1; i++){
    for(int j = 0; j < maxVerticalNodes-1; j++){
      Vector2 diffh = nodes[i][j+1].position.minus(nodes[i][j].position);
      float stringFh = -30*(diffh.length() - 25);

      Vector2 stringDirh = diffh.normalized();
      float projVboth = dot(nodes[i][j].velocityH, stringDirh);
      float projVtoph = dot(nodes[i+1][j].velocityH, stringDirh);
      float dampFh = -kv*(projVtoph - projVboth);

      Vector2 forceh = stringDirh.times(stringFh+dampFh);
      nodes[i][j].addToAcceleration(forceh.times(-1.0/mass));
      nodes[i][j+1].addToAcceleration(forceh.times(1.0/mass));
    }
  }

  //Eulerian integration
  for(int i = 1; i < maxHorizontalNodes; i++){
    for(int j = 0; j < maxVerticalNodes; j++){
      nodes[i][j].addToVelocity(nodes[i][j].acceleration.times(dt));
      nodes[i][j].addToPosition(nodes[i][j].velocity.times(dt));
    }
  }  

  // Collision detection and response
  // for (int i = 0; i < maxHorizontalNodes; i++){
  //  if (pos[i].y+radius > floor){
  //    vel[i].y *= -.9;
  //    pos[i].y = floor - radius;
  //  }
  //  if (pos1[i].y+radius > floor){
  //    vel1[i].y *= -.9;
  //    pos1[i].y = floor - radius;
  //  }
  // }
  
  for(int i = 0; i < maxHorizontalNodes; i++){
    for(int j = 0; j < maxVerticalNodes; j++){
      if (nodes[i][j].position.distanceTo(circlePos) < (circleRad+radius)){
        Vector2 normal = (nodes[i][j].position.minus(circlePos)).normalized();
        nodes[i][j].position = circlePos.plus(normal.times(circleRad+radius).times(1.01));
        Vector2 velNormal = normal.times(dot(nodes[i][j].velocity,normal));
        nodes[i][j].subtractFromVelocity(velNormal.times(1+0.7));
      }
    }
  }
    
  obstacleVel = new Vector2(0,0);
  if (leftPressed) obstacleVel = new Vector2(-obstacleSpeed,0);
  if (rightPressed) obstacleVel = new Vector2(obstacleSpeed,0);
  if (upPressed) obstacleVel = new Vector2(0,-obstacleSpeed);
  if (downPressed) obstacleVel = new Vector2(0,obstacleSpeed);
  circlePos.add(obstacleVel.times(dt));
}

boolean leftPressed, rightPressed, upPressed, downPressed, shiftPressed;

//Draw the scene: one sphere per mass, one line connecting each pair
boolean paused = true;
void draw() {
  background(255,255,255);
  for (int i=0; i < 100; i++){
    if (!paused) update(1/(100*frameRate));
  }
  fill(0,0,0);

  for(int i = 0; i < maxHorizontalNodes-1; i++){
    for(int j = 0; j < maxVerticalNodes-1; j++){
      pushMatrix();
      line(nodes[i][j].position.x, nodes[i][j].position.y,
        nodes[i+1][j].position.x, nodes[i+1][j].position.y);
      if(j != maxVerticalNodes-2){
        line(nodes[i+1][j].position.x, nodes[i+1][j].position.y,
          nodes[i+1][j+1].position.x, nodes[i+1][j+1].position.y);
      }
      translate(nodes[i+1][j].position.x, nodes[i+1][j].position.y);
      sphere(radius);
      popMatrix();
    }
  }
  
  if (paused)
    surface.setTitle(windowTitle + " [PAUSED]");
  else
    surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
  
  fill(180,60,40);
  circle(circlePos.x, circlePos.y, circleRad*2); //(x, y, diameter)
}

void keyPressed(){

  if (keyCode == LEFT) leftPressed = true;
  if (keyCode == RIGHT) rightPressed = true;
  if (keyCode == UP) upPressed = true; 
  if (keyCode == DOWN) downPressed = true;
  if (keyCode == SHIFT) shiftPressed = true;
  
  
  if (key == ' ')
    paused = !paused;
}

void keyReleased(){

  if (keyCode == LEFT) leftPressed = false;
  if (keyCode == RIGHT) rightPressed = false;
  if (keyCode == UP) upPressed = false; 
  if (keyCode == DOWN) downPressed = false;
  if (keyCode == SHIFT) shiftPressed = false;
}