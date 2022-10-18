class Fluid
{
  float leftX;
  float rightX;
  float bottomY;
  float topY;
  float frontZ;
  float backZ;
  float x;
  float z;
  final float dx = 0.5f; // length of x-axis cell
  final float dz = 10.0f; // length of z-axis cell
  float lastXSize;
  float lastZSize;
  int nx; // number of x-axis cells
  int nz; // number of z-axis cells
  // Rectangle[][] rectangles;
  Rectangle[] rectangles;
  RGB rgb = new RGB(156,211,219);
  float ground;
  float g = 1.0f; // gravity
  float damp = 0.9f;
  float scale = 10.0f;


  // Fluid(float leftX, float rightX, float bottomY, float topY, float frontZ, float backZ, float ground) {
  Fluid(float leftX, float rightX, float frontZ, float backZ, float ground) {
    this.leftX = leftX;
    this.rightX = rightX;
    // this.bottomY = bottomY;
    // this.topY = topY;
    this.frontZ = frontZ;
    this.backZ = backZ;
    this.ground = ground;
    // h = bottomY - topY;
    // hu = bottomY - topY;
    x = rightX - leftX;
    nx = (int) (x/dx);
    z = frontZ - backZ;
    nz = (int) (z/dz);
    lastXSize = x - (dx * nx);
    lastZSize = z - (dz * nz);
    // rectangles = new Rectangle[nx][nz]; // uncomment this
    rectangles = new Rectangle[nx];
    initScene();
  }

  void initScene(){
    for(int i = 0; i < nx; i++){
      // for(int j = 0; j < nz; j++){
        float xPos = leftX + ((float) (i) * dx);
        if(i == nx){ // last rectangle, different position and size
          xPos += lastXSize/2.0f;
        } else {
          xPos += dx/2.0f;
        }

        float zPos = frontZ + (z/2.0f);
        // float zPos = frontZ + ((float) (j) * dz);
        // if(j == nz){
        //   zPos += lastZSize/2.0f;
        // } else {
        //   zPos += dz/2.0f;
        // }
        
        Vector3 position = new Vector3(xPos, ground, zPos);
        Vector3 size = new Vector3(dx, 2*i/nx + 1, dz);

        if(i == nx) size.x = lastXSize;
        // if(j == nz) size.z = lastZSize;
        
        rectangles[i] = new Rectangle(position, size, rgb);
      // }
    }
  }

  void Update(float dt){
    // Compute midpoint heights and momentums
    for(int i = 0; i < nx-1; i++){
      // for(int j = 0; j < nz; j++){
        rectangles[i].h_mid = (rectangles[i].size.y + rectangles[i+1].size.y)/2;
        rectangles[i].hu_mid = (rectangles[i].hu + rectangles[i+1].hu)/2;
      // }
    }

    // Compute derivates at midpoints
    for(int i = 0; i < nx-1; i++){
      // for(int j = 0; j < nz; j++){
        // Compute dh/dt (mid)
        float dhudx_mid = (rectangles[i+1].hu - rectangles[i].hu)/dx;
        rectangles[i].dhdt_mid = -dhudx_mid;

        // Compute dhu/dt (mid)   
        float dhu2dx_mid = ((rectangles[i+1].hu * rectangles[i+1].hu) / rectangles[i+1].size.y - (rectangles[i].hu * rectangles[i].hu)/rectangles[i].size.y)/dx;
        float dgh2dx_mid = (g*(rectangles[i+1].size.y * rectangles[i+1].size.y) - (rectangles[i].size.y * rectangles[i].size.y))/dx;
        rectangles[i].dhudt_mid = -(dhu2dx_mid + 0.5*dgh2dx_mid);
      // }
    }

    // Update midpoints for 1/2 a timestep based on midpoint derivatives
    for(int i = 0; i < nx; i++){
      // for(int j = 0; j < nz; j++){
        rectangles[i].h_mid += rectangles[i].dhdt_mid * dt/2;
        rectangles[i].hu_mid += rectangles[i].dhudt_mid*dt/2;
      // }
    }

    // Compute height and momentum updates (non-midpoint)
    for(int i = 1; i < nx-1; i++){
      // for(int j = 0; j < nz; j++){
        // Compute dh/dt
        float dhudx = (rectangles[i].hu_mid - rectangles[i-1].hu_mid)/dx;
        rectangles[i].dhdt = -dhudx;
      
        // Compute dhu/dt
        
        float dhu2dx = ((rectangles[i].hu_mid * rectangles[i].hu_mid)/rectangles[i].h_mid - (rectangles[i-1].hu_mid * rectangles[i-1].hu_mid)/rectangles[i-1].h_mid)/dx;
        float dgh2dx = g*((rectangles[i].h_mid * rectangles[i].h_mid) - (rectangles[i-1].h_mid * rectangles[i-1].h_mid))/dx;
        rectangles[i].dhudt = -(dhu2dx + 0.5*dgh2dx);
      // }
    }

    // Update values (non-midpoint) based on full timestep
    for(int i = 0; i < nx; i++){
      // for(int j = 0; j < nz; j++){
      rectangles[i].size.y += damp * rectangles[i].dhdt * dt;
      rectangles[i].hu += damp * rectangles[i].dhudt * dt;
      // }
    }
    // Reflecting boundary conditions
    rectangles[0].size.y = rectangles[1].size.y;
    rectangles[nx-1].size.y = rectangles[nx-2].size.y;
    rectangles[0].hu = -rectangles[1].hu;
    rectangles[nx-1].hu = -rectangles[nx-2].hu;
  }

  void Draw(){
    for(int i = 0; i < nx; i++){
      // for(int j = 0; j < nz; j++){
        pushMatrix();
        Rectangle rectangle = rectangles[i];
        RGB rgb = rectangle.rgb;
        fill(rgb.r, rgb.g, rgb.b);
        translate(rectangle.position.x, rectangle.position.y, rectangle.position.z);
        box(rectangle.size.x * scale, rectangle.size.y * (scale*2), rectangle.size.z * scale);
        popMatrix();
      // }
    }
  }
}
