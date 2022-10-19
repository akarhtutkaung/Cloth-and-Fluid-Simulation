
class Cloth
{
  //Simulation Parameters
  float ground;
  Vector3 gravity = new Vector3(0,400,0);
  float radius = 1;
  Vector3 stringTop;
  float restLen = 5;
  float mass = 0.1;
  float k = 800;
  float kv = 130;

  float yOffset;
  float xOffset;
  float zOffset;

  boolean debug = false;

  float sizeBetweenX = 1;

  PImage img;
  // MovableObstacleSphere obstacle;
  ObstacleSphere obstacle;

  //Initial positions and velocities of masses
  int maxColumnNodes;
  int maxRowNodes;

  float width = 20.0f;
  float height = 20.0f;

  Node nodes[][];

  Cloth() {
    this.maxColumnNodes = 4;
    this.maxRowNodes = 10;
    this.ground = 0;
    this.stringTop = new Vector3(-100,-50,-200);
    img = loadImage("Assets/carpet.png");
    initPos();
    initUV();
  }

  Cloth(int maxRowNodes, int maxColumnNodes, Vector3 stringTop, float ground) {
    this.maxRowNodes = maxRowNodes;
    this.maxColumnNodes = maxColumnNodes;
    this.ground = ground;
    this.stringTop = stringTop;
    img = loadImage("Assets/carpet.png");
    initPos();
    initUV();
  }

  void addObstacle(ObstacleSphere obstacle){
    this.obstacle = obstacle;
  }

  void setObstaclePosition(Vector3 position){
    this.obstacle.position = position;
  }

  void initPos(){
    nodes = new Node[maxRowNodes][maxColumnNodes];
    
    xOffset = width/maxColumnNodes;
    zOffset = height/maxRowNodes;
    for (int row = 0; row < maxRowNodes; row++){
      float xOffsetTmp = 0;
      for(int col = 0; col < maxColumnNodes; col++){
        float x = stringTop.x + xOffsetTmp + xOffset * row;
        float y = stringTop.y;
        float z = stringTop.z + zOffset * row;
        Vector3 pos = new Vector3(x, y, z);
        nodes[row][col] = new Node(pos);
        xOffsetTmp += sizeBetweenX;
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
        float stringFh = -30*(diffh.length() - sizeBetweenX);

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

     //Collision detection and response with the ground
     for(int row = 0; row < maxRowNodes; row++){
      for(int col = 0; col < maxColumnNodes; col++){
        if(ground - (nodes[row][col].position.y + radius) < 0.3f ){
          nodes[row][col].velocity.y = 0;
        }
        if(nodes[row][col].position.y + radius > ground){
          nodes[row][col].velocity.y *= -.9;
          nodes[row][col].position.y = ground - radius;
        }
      }
     }
    
    // // Collision with the obstacle
    if(obstacle != null){
      for(int row = 0; row < maxRowNodes; row++){
        for(int col = 0; col < maxColumnNodes; col++){
          if (nodes[row][col].position.distanceTo(obstacle.position) < (obstacle.radius+radius)){
            Vector3 normal = (nodes[row][col].position.minus(obstacle.position)).normalized();
            nodes[row][col].position = obstacle.position.plus(normal.times(obstacle.radius+radius).times(1.01));
            Vector3 velNormal = normal.times(dot(nodes[row][col].velocity,normal));
            nodes[row][col].subtractFromVelocity(velNormal.times(1+0.7));
          }
        }
      }
    }
  }

  //Draw the scene: one sphere per mass, one line connecting each pair
  void Draw() {
    fill(0,0,0);
    for(int i = 0; i < maxRowNodes-1; i++){
      for(int j = 0; j < maxColumnNodes-1; j++){
        pushMatrix();
        if(debug == true){
          stroke(255);
          strokeWeight(2);
        }
        line(nodes[i][j].position.x, nodes[i][j].position.y, nodes[i][j].position.z, nodes[i+1][j].position.x, nodes[i+1][j].position.y, nodes[i+1][j].position.z);
        if(j != maxColumnNodes-2){
          line(nodes[i+1][j].position.x, nodes[i+1][j].position.y, nodes[i+1][j].position.z, nodes[i+1][j+1].position.x, nodes[i+1][j+1].position.y, nodes[i+1][j+1].position.z);
        }
        translate(nodes[i+1][j].position.x, nodes[i+1][j].position.y, nodes[i+1][j].position.z);
        popMatrix();
      }
    } 
    
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
  }

  void HandleKeyPressed(){
    if ( key == '\\' ) debug = !debug;
  }
}
