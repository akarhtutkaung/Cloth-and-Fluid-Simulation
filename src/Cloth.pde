
class Cloth
{
  float obstacleSpeed = 300;
  Vector3 obstacleVel = new Vector3(0,0,0);

  //Simulation Parameters
  float floor = 500;
  Vector3 gravity = new Vector3(0,400,0);
  float radius = 1;
  Vector3 stringTop = new Vector3(-100,-50,-200);
  float restLen = 5;
  float mass = 1;
  float k = 500;
  float kv = 100;

  float circleRad = 50;

  int yOffset = 3;
  int xOffset = 3;
  int zOffset = 3;

  PImage img;

  //Initial positions and velocities of masses
  int maxColumnNodes;
  int maxRowNodes;

  Node nodes[][];
  // Vector3 circlePos = new Vector3(200,200);

  Cloth() {
    this.maxColumnNodes = 10;
    this.maxRowNodes = 10;
    initPos();
    img = loadImage("Assets/carpet.png");
    initUV();
  }

  Cloth(int maxRowNodes, int maxColumnNodes) {
    this.maxRowNodes = maxRowNodes;
    this.maxColumnNodes = maxColumnNodes;
    img = loadImage("Assets/carpet.png");
    initPos();
    initUV();
  }

  void initPos(){
    nodes = new Node[maxRowNodes][maxColumnNodes];
    for (int i = 0; i < maxRowNodes; i++){
      float xOffsetTmp = 0;
      for(int j = 0; j < maxColumnNodes; j++){
        float x = stringTop.x + xOffsetTmp + xOffset * i;
        float y = stringTop.y + yOffset * i;
        float z = stringTop.z + zOffset * i;
        Vector3 pos = new Vector3(x, y, z);
        nodes[i][j] = new Node(pos);
        xOffsetTmp += 25;
      }
    }
  }

  void initUV(){
    float deltaX = 1.0f / maxColumnNodes;
    float deltaY = 1.0f / maxRowNodes;
    for (int row = 0; row < maxRowNodes; row++){
      for(int col = 0; col < maxColumnNodes; col++){
        nodes[row][col].setUV(col * deltaX, row * deltaY);
      }
    }
  }

  void Update(float dt){
    //Reset accelerations each timestep (momenum only applies to velocity)
    for(int i = 0; i < maxRowNodes; i++){
      for(int j = 0; j < maxColumnNodes; j++){
        nodes[i][j].resetAcceleration();
        nodes[i][j].resetAccelerationH();
        nodes[i][j].addToAcceleration(gravity);
      }
    }
    
    //Compute (damped) Hooke's law for each spring
    for(int i = 0; i < maxRowNodes-1; i++){
      for(int j = 0; j < maxColumnNodes; j++){
        Vector3 diff = nodes[i+1][j].position.minus(nodes[i][j].position);
        float stringF = -k*(diff.length() - restLen);
        
        Vector3 stringDir = diff.normalized();
        float projVbot = dot(nodes[i][j].velocity, stringDir);
        float projVtop = dot(nodes[i+1][j].velocity, stringDir);
        float dampF = -kv*(projVtop - projVbot);

        Vector3 force = stringDir.times(stringF+dampF);
        nodes[i][j].addToAcceleration(force.times(-1.0/mass));
        nodes[i+1][j].addToAcceleration(force.times(1.0/mass));
      }
    }  
    
    // Compute (damped) Hooke's law for each spring H
    for(int i = 0; i < maxRowNodes-1; i++){
      for(int j = 0; j < maxColumnNodes-1; j++){
        Vector3 diffh = nodes[i][j+1].position.minus(nodes[i][j].position);
        float stringFh = -30*(diffh.length() - 25);

        Vector3 stringDirh = diffh.normalized();
        float projVboth = dot(nodes[i][j].velocityH, stringDirh);
        float projVtoph = dot(nodes[i+1][j].velocityH, stringDirh);
        float dampFh = -kv*(projVtoph - projVboth);

        Vector3 forceh = stringDirh.times(stringFh+dampFh);
        nodes[i][j].addToAcceleration(forceh.times(-1.0/mass));
        nodes[i][j+1].addToAcceleration(forceh.times(1.0/mass));
      }
    }

    //Eulerian integration
    for(int i = 1; i < maxRowNodes; i++){
      for(int j = 0; j < maxColumnNodes; j++){
        nodes[i][j].addToVelocity(nodes[i][j].acceleration.times(dt));
        nodes[i][j].addToPosition(nodes[i][j].velocity.times(dt));
      }
    }  

    // Collision detection and response
    // for (int i = 0; i < maxRowNodes; i++){
    //  if (pos[i].y+radius > floor){
    //    vel[i].y *= -.9;
    //    pos[i].y = floor - radius;
    //  }
    //  if (pos1[i].y+radius > floor){
    //    vel1[i].y *= -.9;
    //    pos1[i].y = floor - radius;
    //  }
    // }
    
    // // Collision with the obstacle
    // for(int i = 0; i < maxRowNodes; i++){
    //   for(int j = 0; j < maxColumnNodes; j++){
    //     if (nodes[i][j].position.distanceTo(circlePos) < (circleRad+radius)){
    //       Vector3 normal = (nodes[i][j].position.minus(circlePos)).normalized();
    //       nodes[i][j].position = circlePos.plus(normal.times(circleRad+radius).times(1.01));
    //       Vector3 velNormal = normal.times(dot(nodes[i][j].velocity,normal));
    //       nodes[i][j].subtractFromVelocity(velNormal.times(1+0.7));
    //     }
    //   }
    // }
      
    obstacleVel = new Vector3(0,0, 0);
    if (leftPressed) obstacleVel = new Vector3(-obstacleSpeed,0, 0);
    if (rightPressed) obstacleVel = new Vector3(obstacleSpeed,0, 0);
    if (upPressed) obstacleVel = new Vector3(0,-obstacleSpeed, 0);
    if (downPressed) obstacleVel = new Vector3(0,obstacleSpeed, 0);
    // circlePos.add(obstacleVel.times(dt));
  }

  boolean leftPressed, rightPressed, upPressed, downPressed, shiftPressed;

  //Draw the scene: one sphere per mass, one line connecting each pair
  void Draw() {
    fill(0,0,0);
    for(int i = 0; i < maxRowNodes-1; i++){
      for(int j = 0; j < maxColumnNodes-1; j++){
        pushMatrix();
        line(nodes[i][j].position.x, nodes[i][j].position.y, nodes[i][j].position.z, nodes[i+1][j].position.x, nodes[i+1][j].position.y, nodes[i+1][j].position.z);
        if(j != maxColumnNodes-2){
          line(nodes[i+1][j].position.x, nodes[i+1][j].position.y, nodes[i+1][j].position.z, nodes[i+1][j+1].position.x, nodes[i+1][j+1].position.y, nodes[i+1][j+1].position.z);
        }
        translate(nodes[i+1][j].position.x, nodes[i+1][j].position.y, nodes[i+1][j].position.z);
        // sphere(radius);
        popMatrix();
      }
    } 
    
    // stroke(255);
    // strokeWeight(2);
    // noFill();
    for(int row = 0; row < maxRowNodes-1; row++){
      textureMode(NORMAL);
      beginShape(TRIANGLE_STRIP);
      texture(img);
      noStroke();
      for(int col = 0; col < maxColumnNodes; col++){
        Node node0 = nodes[row][col];
        Node node1 = nodes[row+1][col];
        vertex(node1.position.x, node1.position.y, node1.position.z, node1.u, node1.v);
        vertex(node0.position.x, node0.position.y, node0.position.z, node0.u, node0.v);
      }
      endShape();
    }

    // surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
    // fill(180,60,40);
    // circle(circlePos.x, circlePos.y, circleRad*2); //(x, y, diameter)
  }

  // void keyPressed(){

  //   if (keyCode == LEFT) leftPressed = true;
  //   if (keyCode == RIGHT) rightPressed = true;
  //   if (keyCode == UP) upPressed = true; 
  //   if (keyCode == DOWN) downPressed = true;
  //   if (keyCode == SHIFT) shiftPressed = true;

  // void keyReleased(){
  //   if (keyCode == LEFT) leftPressed = false;
  //   if (keyCode == RIGHT) rightPressed = false;
  //   if (keyCode == UP) upPressed = false; 
  //   if (keyCode == DOWN) downPressed = false;
  //   if (keyCode == SHIFT) shiftPressed = false;
  // }

}